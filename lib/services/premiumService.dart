import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:videotor/controllers/index.dart';
import 'package:videotor/helpers/index.dart';
import 'package:videotor/data/entities/index.dart';
import 'package:videotor/services/index.dart';

class PremiumService extends GetxService {
  PremiumService init() {
    return this;
  }

  bool isRewarded() {
    final rxAppSettings = Get.find<User>().appSettings.value;
    final registeredDate = rxAppSettings.rewardDate.value.toDateTime();
    final thereIsTime = registeredDate != null
        ? registeredDate.isAfter(DateTime.now().subtract(Duration(days: 1)))
        : false;
    return !kReleaseMode || thereIsTime;
  }

  bool isPurchased() {
    final rxAppSettings = Get.find<User>().appSettings.value;
    final purchased = rxAppSettings.purchased.value == 1;
    return purchased;
  }

  bool get isPremium => isRewarded() || isPurchased();

  Future<bool> setPurchased(bool buyed) async {
    final repo = DataService.repositoryOf<AppSettings>();
    final appSettings =
        (await DataService.repositoryOf<User>().first()).appSettings.value;
    appSettings.purchased.value = buyed ? 1 : 0;
    Get.find<User>().appSettings.value.purchased.value =
        appSettings.purchased.value;
    Get.find<HomeController>().loadPremium();
    return (await repo.updateColumns(appSettings, ['purchased'])) > 0;
  }

  Future<void> setRewarded() async {
    final rxAppSettings = Get.find<User>().appSettings.value;
    rxAppSettings.rewardDate.value = DateTime.now().toString();
    final appSettings =
        (await DataService.repositoryOf<User>().first()).appSettings.value;
    appSettings.rewardDate.value = rxAppSettings.rewardDate.value;
    await DataService.repositoryOf<AppSettings>()
        .updateColumns(appSettings, ['rewardDate']);
    Get.find<HomeController>().loadPremium();
  }
}
