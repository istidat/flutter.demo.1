import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:videotor/data/entities/index.dart';
import 'package:videotor/data/metadata/index.dart';
import 'package:videotor/helpers/index.dart';
import 'package:videotor/services/dataService.dart';
import 'package:videotor/services/index.dart';

class AppSettings extends GenericEntity<AppSettings> {
  var purchased = 0.obs;
  var rewardDate = "".obs;
  var locale = "".obs;
  var vibrationOff = 0.obs;
  var dhikrColor = "".obs;

  var rewardDays = 1;

  Rx<User> user = Rx<User>();

  Color get currentDhikrColor {
    if (dhikrColor.value.isEmpty) {
      return Colors.orange[500];
    } else {
      final valueString =
          dhikrColor.value.split('(0x')[1].split(')')[0]; // kind of hacky..
      final value = int.parse(valueString, radix: 16);
      return Color(value);
    }
  }

  setLocalization(BuildContext context, AppLocale appLocale) {
    final lc = AppLocales[appLocale];
    EasyLocalization.of(context).locale = lc;
    locale.value = appLocale.repr;
  }

  void setCurrentDhikrColor(Color color) async {
    dhikrColor.value = color.toString();
    await DataService.repositoryOf<AppSettings>()
        .updateColumns(this, ['dhikrColor']);
  }

  void toggleVibrationMode() async {
    vibrationOff.value = vibrationOff.value == 0 ? 1 : 0;
    await DataService.repositoryOf<AppSettings>()
        .updateColumns(this, ['vibrationOff']);
  }

  Future<void> purchaseIAP(
    ProductDetails item, {
    Function(IAPError error) onError,
  }) async {
    final iapService = Get.find<IAPService>();
    await iapService.initConnection(
      onError: onError,
    );
    await iapService.purchase(item);
  }

  @override
  String toString() => purchased.value == 1 ? "Satın Alındı" : "Demo Version";

  @override
  TableInfo<AppSettings> get tableInfo => TableInfo<AppSettings>(
        version: 1,
        tableName: "app_settings",
        resource: "app-settings",
        translation: "entity.app_settings",
        fieldInfos: [
          FieldInfo(
            name: "purchased",
            translation: "entity.app_settings.purchased",
            dataType: DataType.int,
            prop: Prop(
              getter: (e) => e.purchased.value,
              setter: (e, val) => e.purchased.value = val,
            ),
          ),
          FieldInfo(
            name: "rewardDate",
            translation: "entity.app_settings.rewardDate",
            prop: Prop(
              getter: (e) => e.rewardDate.value,
              setter: (e, val) => e.rewardDate.value = val,
            ),
          ),
          FieldInfo(
            name: "locale",
            translation: "entity.app_settings.locale",
            prop: Prop(
              getter: (e) => e.locale.value,
              setter: (e, val) => e.locale.value = val,
            ),
          ),
          FieldInfo(
            name: "vibrationOff",
            translation: "entity.app_settings.vibrationOff",
            dataType: DataType.int,
            prop: Prop(
              getter: (e) => e.vibrationOff.value,
              setter: (e, val) => e.vibrationOff.value = val,
            ),
          ),
          FieldInfo(
            name: "dhikrColor",
            translation: "entity.app_settings.dhikrColor",
            prop: Prop(
              getter: (e) => e.dhikrColor.value,
              setter: (e, val) => e.dhikrColor.value = val,
            ),
          ),
        ],
        one2OneReferences: [
          One2OneReferenceInfo(
            child: true,
            prop: Prop(
              getter: (e) => e.user.value,
              setter: (e, val) => e.user.value = val,
            ),
            referenceRepository: DataService.repositoryOf<AppSettings>(),
            foreignTable: DataService.tableNameOf<User>(),
            referencingColumn: "user_id",
          ),
        ],
      );

  @override
  int get hashCode =>
      purchased.hashCode ^
      rewardDate.hashCode ^
      locale.hashCode ^
      vibrationOff.hashCode ^
      dhikrColor.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSettings &&
          purchased == other.purchased &&
          rewardDate == other.rewardDate &&
          locale == other.locale &&
          vibrationOff == other.vibrationOff &&
          dhikrColor == other.dhikrColor;
}
