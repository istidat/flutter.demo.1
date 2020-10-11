import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';

class AdManager {
  static String get appId {
    if (Platform.isAndroid) {
      return "ca-app-pub-7886619676351440~8115233556";
    } else if (Platform.isIOS) {
      return "ca-app-pub-7886619676351440~8107494698";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-7886619676351440/3198960551";
    } else if (Platform.isIOS) {
      return "ca-app-pub-7886619676351440/8368700215";
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
      return "ca-app-pub-7886619676351440/8857986500";
    } else if (Platform.isIOS) {
      return "ca-app-pub-7886619676351440/1817418516";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: [
      'zakiriyn',
      'zikir',
      'zikirmatik',
      'zikir matik',
      'zikir çekmek',
      'zikir uygulaması',
      'zikir çekme uygulaması',
      'zikirmatik tesbih'
    ],
    contentUrl: 'http://zakiriyn.com',
    childDirected: false,
    testDevices: [
      "E7DF57898E5C901DB709D886548F487F", // D6503
      "828251ea21382cba0edf3b703fbcc5e6" //iphone 6s
    ],
  );
}
