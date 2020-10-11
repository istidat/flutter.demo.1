import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easy_localization/easy_localization.dart';

class AppPage<TController extends GetxController> extends GetView<TController> {
  Widget get title => Text(
        translationKey.value,
        style: TextStyle(fontSize: 18.0),
      ).tr();

  final RxList<Widget> actions = <Widget>[].obs;
  final Rx<Widget> icon = Rx<Icon>();
  final RxString translationKey = "".obs;
  final RxString alternativeTranslationKey = RxString()..value = null;
  final Rx<Widget> floatingButton = Rx<FloatingActionButton>();

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
