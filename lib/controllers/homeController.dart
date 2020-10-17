import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:videotor/helpers/index.dart';
import 'package:videotor/tabs/about/about_page.dart';
import 'package:videotor/tabs/app_page.dart';
import 'package:videotor/tabs/app_settings/app_settings_page.dart';
import 'package:videotor/services/index.dart';
import 'package:videotor/tabs/video_edit/index.dart';

class HomeController extends GetxController {
  final pages = <AppPage>[
    VideoPage(),
    AppSettingsPage(),
    AboutPage(),
  ];

  RxDouble fabElevation = 0.0.obs;
  var pageIndex = 0.obs;
  Rx<AppBar> appBar = Rx<AppBar>();
  Rx<FloatingActionButton> floatingButton = Rx<FloatingActionButton>();

  void loadPremium() async {
    final premiumService = Get.find<PremiumService>();
    final adService = Get.find<AdService>();
    if (premiumService.isPremium) {
      adService.hideBanner();
    } else {
      adService.showBanner();
    }
  }

  void setParams(int pageIndex) {
    final ctrl = pages[pageIndex];
    Get.find<UIService>().setHomeParams(
      appBar: AppBar(
        title: Obx(() => ctrl.title),
        actions: ctrl.actions,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu, color: vividTitleColor),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      floatingButton: ctrl.floatingButton,
    );
  }

  void adjoinFAB({bool cancel: false}) async {
    final adService = Get.find<AdService>();
    if (cancel == false) {
      fabElevation.value = adService.adHeight.value;
    } else {
      fabElevation.value = 0.0;
    }
  }

  Widget get bottomNavigationBar {
    final adService = Get.find<AdService>();
    return Obx(() => Padding(
          padding: EdgeInsets.only(bottom: adService.adHeight.value),
          child: BottomNavigationBar(
            currentIndex: pageIndex.value,
            backgroundColor: Colors.grey[900],
            type: BottomNavigationBarType.fixed,
            iconSize: 20.0,
            selectedFontSize: 10.0,
            unselectedFontSize: 10.0,
            selectedItemColor: vividTitleColor,
            unselectedItemColor: Colors.white,
            items: pages
                .map((page) => BottomNavigationBarItem(
                      icon: page.icon.value,
                      label: (page.alternativeTranslationKey.value
                              .ifNull(elseThen: page.translationKey.value))
                          .tr(),
                    ))
                .toList(),
            onTap: (index) {
              pageIndex.value = index;
              setParams(index);
            },
          ),
        ));
  }
}
