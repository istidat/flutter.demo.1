import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';

class AdManager {
  static String get appId {
    if (Platform.isAndroid) {
      return "ca-app-pub-7886619676351440~4680714568";
    } else if (Platform.isIOS) {
      return "ca-app-pub-7886619676351440~7602391371";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-7886619676351440/7821883221";
    } else if (Platform.isIOS) {
      return "ca-app-pub-7886619676351440/8943393201";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "";
    } else if (Platform.isIOS) {
      return "";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-7886619676351440/2541636380";
    } else if (Platform.isIOS) {
      return "ca-app-pub-7886619676351440/8723901358";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: [
      'videotor',
      'video',
      'videolar',
      'video edit',
      'video editor',
      'video düzenleme',
      'video yapma',
      'video düzenleyici',
      'ekran kayıt',
      'ekran resmi alma',
    ],
    contentUrl: 'http://zakiriyn.com',
    childDirected: false,
    testDevices: [
      "E7DF57898E5C901DB709D886548F487F", // D6503
      "828251ea21382cba0edf3b703fbcc5e6" //iphone 6s
    ],
  );
}
