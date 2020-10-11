import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:videotor/components/forms/options_form.dart';
import 'package:videotor/services/index.dart';

class IAPModel implements OptionForm {
  final ProductDetails item;

  static Future<List<IAPModel>> get models async {
    final iapService = Get.find<IAPService>();
    final items = await iapService.getSubscriptions();
    return items.map((it) => IAPModel(it)).toList();
  }

  IAPModel(this.item);

  @override
  Widget get subtitle => Text("title.you_can_purchase_with").tr(
        args: ["${this.item.price}"],
      );

  @override
  Widget get title => Text("${this.item.title}");
}
