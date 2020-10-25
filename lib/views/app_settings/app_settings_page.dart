import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart' hide Trans;
import 'package:settings_ui/settings_ui.dart';
import 'package:videotor/components/forms/index.dart';
import 'package:videotor/data/entities/index.dart';
import 'package:videotor/helpers/index.dart';
import 'package:videotor/models/index.dart';
import 'package:videotor/services/index.dart';
import 'package:videotor/views/app_page.dart';

class AppSettingsPage extends AppPage<User> {
  @override
  get translationKey => 'title.app_settings_page'.obs;

  @override
  get icon => Icon(Icons.settings).obs;

  final PremiumService _premiumService = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SettingsList(
        sections: [
          SettingsSection(
            title: 'title.section_common'.tr(),
            tiles: [
              SettingsTile(
                title: 'title.language'.tr(),
                subtitle: 'app.language'.tr(),
                leading: FaIcon(
                  FontAwesomeIcons.language,
                  color: Colors.blueAccent,
                ),
                onTap: () async {
                  final model = await Get.to(
                    OptionsForm.of(
                      titleTranslation: 'title.language',
                      options: LanguageModel.appLocaleOptions,
                    ),
                  );
                  if (model != null) {
                    controller.appSettings.value
                        .setLocalization(context, model.appLocale);
                  }
                },
              ),
            ],
          ),
          SettingsSection(
            title: 'title.section_purchase'.tr(),
            tiles: [
              SettingsTile(
                title: _premiumService.isPremium
                    ? 'title.rewardad_watched'.tr()
                    : 'title.watch_videoad'.tr(),
                subtitle: (_premiumService.isPremium
                        ? 'title.premium_active_for'
                        : 'title.for_specified_days')
                    .tr(args: ["${controller.appSettings.value.rewardDays}"]),
                leading: FaIcon(
                  FontAwesomeIcons.video,
                  color: _premiumService.isPremium
                      ? Colors.grey
                      : Colors.redAccent,
                ),
                enabled: _premiumService.isPremium == false,
                onTap: () {
                  UIHelper.alert(
                      title: 'title.video_ad_will_show'.tr(),
                      message: 'message.video_ad_will_show'.tr(
                          args: ["${controller.appSettings.value.rewardDays}"]),
                      approvalText: 'alert.continue'.tr(),
                      onApproval: () {
                        Get.find<AdService>().loadRewardedAd(
                          () async {
                            await _premiumService.setRewarded();
                            UIHelper.alert(
                              title: 'title.success_to_reward'.tr(),
                              message: 'message.success_to_reward'.tr(args: [
                                "${controller.appSettings.value.rewardDays}"
                              ]),
                              multipleChoice: false,
                            );
                          },
                          () => UIHelper.snack(
                            title: 'title.failed_to_reward'.tr(),
                            message: 'message.failed_to_reward'.tr(),
                          ),
                        );
                      });
                },
              ),
              SettingsTile(
                title: _premiumService.isPurchased()
                    ? 'title.premium_purchased'.tr()
                    : 'title.purchase_premium'.tr(),
                subtitle: (_premiumService.isPurchased()
                        ? 'title.premium_is_active_annual'
                        : 'title.premium_for_annual')
                    .tr(args: ["${controller.appSettings.value.rewardDays}"]),
                leading: FaIcon(
                  FontAwesomeIcons.shoppingCart,
                  color: _premiumService.isPurchased()
                      ? Colors.grey
                      : Colors.greenAccent,
                ),
                enabled: _premiumService.isPurchased() == false,
                onTap: () async {
                  final model = await Get.to(
                    OptionsForm.of(
                      titleTranslation: 'title.purchase_premium',
                      options: await IAPModel.models,
                    ),
                  );
                  if (model == null) {
                    UIHelper.snack(
                      title: "title.purchase_cancelled".tr(),
                      message: "message.purchase_cancelled".tr(),
                    );
                  } else {
                    await controller.appSettings.value.purchaseIAP(
                        (model as IAPModel).item, onError: (error) {
                      UIHelper.snack(
                        title: 'title.failed_to_purchase'.tr(),
                        message:
                            error.message == "BillingResponse.itemAlreadyOwned"
                                ? 'message.iap_already_owned'.tr()
                                : 'message.failed_to_purchase'.tr(),
                      );
                    });
                  }
                },
              ),
              SettingsTile(
                title: 'title.restore_purchases'.tr(),
                subtitle: 'message.restore_purchases'.tr(),
                leading: FaIcon(
                  FontAwesomeIcons.cartArrowDown,
                  color: Colors.deepOrangeAccent,
                ),
                onTap: Get.find<IAPService>().restorePurchases,
              ),
            ],
          ),
          SettingsSection(
            title: 'title.section_system'.tr(),
            tiles: [
              SettingsTile(
                title: 'title.vibration_switch'.tr(),
                subtitle: controller.appSettings.value.vibrationOff.value == 0
                    ? 'title.vibration_on'.tr()
                    : 'title.vibration_off'.tr(),
                leading: controller.appSettings.value.vibrationOff.value == 0
                    ? FaIcon(
                        FontAwesomeIcons.bell,
                        color: Colors.pinkAccent,
                      )
                    : FaIcon(
                        FontAwesomeIcons.bellSlash,
                        color: Colors.pinkAccent,
                      ),
                onTap: controller.appSettings.value.toggleVibrationMode,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
