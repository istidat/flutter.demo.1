import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:videotor/components/index.dart';
import 'package:videotor/controllers/index.dart';
import 'package:videotor/services/index.dart';

Future<void> init({bool test: false}) async {
  WidgetsBinding.instance.addObserver(
    LifecycleEventHandler(
      detachedCallBack: () async {
        //  await SystemNavigator.pop();
      },
      resumeCallBack: () async {},
    ),
  );
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await Get.putAsync(() => DataService().init());
  await Get.putAsync(() => UserService().init());
  await Get.putAsync(() => IAPService().init());
  await _initControllers();
  Get.putAsync(() => AdService().init());
  Get.lazyPut(() => UIService().init());
  Get.lazyPut(() => PremiumService().init());
}

Future<void> _initControllers() async {
  Get.lazyPut(() => HomeController());
  Get.lazyPut(() => ProjectListingController());
  Get.lazyPut(() => VideoListingController());
  return await Future(() {});
}
