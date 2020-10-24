import 'package:firebase_admob/firebase_admob.dart';
import 'package:get/get.dart';
import 'package:videotor/services/index.dart';

class AdService extends GetxService {
  Future<AdService> init() async {
    await FirebaseAdMob.instance.initialize(appId: AdManager.appId);
    return this;
  }

  var _bannerDisposed = false.obs;
  var rewardedAdReady = false.obs;
  var adHeight = 0.0.obs;
  BannerAd _bannerAd;

  BannerAd _getBannerAd() {
    return BannerAd(
        targetingInfo: AdManager.targetingInfo,
        adUnitId: AdManager.bannerAdUnitId,
        size: AdSize.fullBanner,
        listener: (MobileAdEvent event) async {
          if (event == MobileAdEvent.loaded) {
            if (_bannerDisposed.value)
              await _bannerAd.dispose();
            else
              await _bannerAd.show();
          }
        });
  }

  void showBanner() async {
    _bannerDisposed.value = false;
    if (_bannerAd == null) {
      _bannerAd = _getBannerAd();
    }
    await _bannerAd.load();
    adHeight.value = _bannerAd.size.height.toDouble();
  }

  void hideBanner() async {
    await _bannerAd?.dispose();
    _bannerDisposed.value = true;
    _bannerAd = null;
    adHeight.value = 0.0;
  }

  void loadRewardedAd(Function() onRewarded, Function() onFailed) {
    rewardedAdReady.value = false;
    RewardedVideoAd.instance
      ..load(
        targetingInfo: AdManager.targetingInfo,
        adUnitId: AdManager.rewardedAdUnitId,
      ).catchError((e) => print("error in loading again"))
      ..listener = event(onRewarded, onFailed);
  }

  Function(Future<void> Function() onRewarded, Function() onFailed) get event =>
      (onRewarded, onFailed) => (RewardedVideoAdEvent event,
              {String rewardType, int rewardAmount}) async {
            switch (event) {
              case RewardedVideoAdEvent.loaded:
                rewardedAdReady.value = true;
                await RewardedVideoAd.instance.show();
                break;
              case RewardedVideoAdEvent.closed:
                rewardedAdReady.value = false;
                break;
              case RewardedVideoAdEvent.failedToLoad:
                rewardedAdReady.value = false;
                onFailed();
                break;
              case RewardedVideoAdEvent.rewarded:
                await onRewarded();
                break;
              default:
              // do nothing
            }
          };
}
