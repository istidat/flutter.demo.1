import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:videotor/controllers/homeController.dart';
import 'package:videotor/helpers/index.dart';

class AppPage<TController extends GetxController> extends StatelessWidget {
  TController get controller => Get.find<TController>();
  Widget get title => Text(
        translationKey.value,
        style: TextStyle(fontSize: 18.0),
      ).tr();

  final RxList<Widget> actions = <Widget>[].obs;
  final Rx<Widget> icon = Rx<Icon>();
  final RxString translationKey = "".obs;
  final RxString alternativeTranslationKey = RxString()..value = null;
  final Rx<Widget> floatingButton = Rx<FloatingActionButton>();

  Function() get onTap => () => {};
  AppBar get appBar => AppBar(
        title: Obx(() => title),
        actions: actions,
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
      );

  Widget buildThe(Widget center, {bool withDrawer: false}) {
    return Scaffold(
      appBar: withDrawer
          ? appBar
          : AppBar(title: Obx(() => title), actions: actions),
      floatingActionButton: floatingButton.value != null
          ? Obx(() => Padding(
                padding: EdgeInsets.only(
                  bottom: Get.find<HomeController>().fabElevation.value,
                ),
                child: floatingButton.value,
              ))
          : null,
      body: SafeArea(child: center),
    );
  }

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
