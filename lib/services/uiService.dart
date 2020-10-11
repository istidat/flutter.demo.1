import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:videotor/controllers/index.dart';

class UIService extends GetxService {
  UIService init() {
    return this;
  }

  setHomeParams({AppBar appBar, Rx<FloatingActionButton> floatingButton}) {
    final controller = Get.find<HomeController>();
    if (appBar != null) {
      controller.appBar = appBar.obs;
    }
    if (floatingButton != null) {
      controller.floatingButton = floatingButton;
    }
  }
}
