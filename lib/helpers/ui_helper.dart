import 'package:get/get.dart' hide Trans;
import 'package:vibration/vibration.dart';
import 'package:videotor/helpers/index.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:videotor/services/index.dart';

enum VibrateMode { thin, short, long, intermittent }

class UIHelper {
  static double modifySizeOf(
      BuildContext context, double Function(Size size) byModifier) {
    return byModifier(MediaQuery.of(context).size);
  }

  static vibrate(VibrateMode mode) async {
    if (await Vibration.hasCustomVibrationsSupport()) {
      switch (mode) {
        case VibrateMode.thin:
          Vibration.vibrate(duration: 150);
          break;
        case VibrateMode.short:
          Vibration.vibrate(duration: 500);
          break;
        case VibrateMode.long:
          Vibration.vibrate(duration: 1000);
          break;
        case VibrateMode.intermittent:
          Vibration.vibrate(duration: 300, repeat: 3);
          break;
        default:
          Vibration.vibrate(duration: 500);
          break;
      }
    } else {
      Vibration.vibrate();
      switch (mode) {
        case VibrateMode.thin:
          await Future.delayed(Duration(milliseconds: 150));
          break;
        case VibrateMode.short:
          await Future.delayed(Duration(milliseconds: 500));
          break;
        case VibrateMode.long:
          await Future.delayed(Duration(milliseconds: 1000));
          break;
        case VibrateMode.intermittent:
          await Future.delayed(Duration(milliseconds: 300));
          Vibration.vibrate();
          await Future.delayed(Duration(milliseconds: 300));
          break;
        default:
          await Future.delayed(Duration(milliseconds: 500));
          break;
      }
      Vibration.vibrate();
    }
  }

  static Future<T> actionSheet<T>(
      {@required String title,
      String message,
      Iterable<SheetAction> actions,
      bool dismissible: false}) async {
    final cancelButton = actions.firstWhere(
      (action) => action.isCancelButton,
      orElse: () => null,
    );
    final adHeight = Get.find<AdService>().adHeight.value;
    return await Get.bottomSheet(
      Padding(
        padding: EdgeInsets.only(bottom: adHeight),
        child: CupertinoActionSheet(
          title: Text(title),
          message: message == null || message.isEmpty ? null : Text(message),
          actions: actions.where((action) => !action.isCancelButton).map(
            (action) {
              List<Widget> actionWidgets = [
                Text(
                  action.title,
                  style: TextStyle(fontSize: 20.0, color: action.color),
                ),
              ];
              return CupertinoActionSheetAction(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: action.subtitle == null
                      ? actionWidgets
                      : (actionWidgets
                        ..addAll([
                          SizedBox(height: 8.0),
                          Text(
                            action.subtitle,
                            style:
                                TextStyle(fontSize: 12.0, color: action.color),
                          ),
                        ])),
                ),
                onPressed: () {
                  if (action.response != null) {
                    Get.back(result: action.response);
                  } else {
                    Get.back();
                  }
                  if (action.onPress != null) {
                    action.onPress();
                  }
                },
                isDefaultAction: action.isDefault,
              );
            },
          ).toList(),
          cancelButton: cancelButton == null
              ? CupertinoActionSheetAction(
                  child: Text("alert.cancel").tr(),
                  isDefaultAction: true,
                  onPressed: () {
                    Get.back(result: 'cancel');
                  },
                )
              : CupertinoActionSheetAction(
                  child: Text(
                    cancelButton.title,
                    style: TextStyle(fontSize: 24.0, color: cancelButton.color),
                  ),
                  onPressed: () {
                    if (cancelButton.onPress != null) {
                      cancelButton.onPress();
                    }
                    Get.back(result: cancelButton.response);
                  },
                  isDefaultAction: cancelButton.isDefault,
                ),
        ),
      ),
      isDismissible: dismissible,
    );
  }

  static Future<T> alert<T>({
    @required String title,
    @required String message,
    bool multipleChoice: true,
    String approvalText,
    String cancellationText,
    void Function() onApproval,
    void Function() onCancellation,
  }) async {
    return await Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        titleTextStyle:
            TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        contentTextStyle:
            TextStyle(fontWeight: FontWeight.w300, color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        elevation: 3.0,
        actions: [
          (multipleChoice
              ? FlatButton(
                  textColor: Colors.redAccent,
                  onPressed: () {
                    if (onCancellation != null) {
                      onCancellation();
                    }
                    Get.back(result: 'cancel');
                  },
                  child: Text(cancellationText ?? "alert.cancel".tr()),
                )
              : null),
          FlatButton(
            textColor: Colors.green,
            onPressed: () {
              if (onApproval != null) {
                onApproval();
              }
              Get.back(result: 'ok');
            },
            child: Text(approvalText ?? "alert.ok".tr()),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  static void snack(
      {String title,
      String message,
      SnackPosition snackPosition: SnackPosition.BOTTOM,
      bool instantInit: true}) async {
    final adHeight = Get.find<AdService>().adHeight.value;
    Get.snackbar(
      title,
      message,
      snackPosition: snackPosition,
      margin: snackPosition == SnackPosition.BOTTOM
          ? EdgeInsets.only(bottom: adHeight)
          : EdgeInsets.only(top: adHeight),
      instantInit: instantInit,
      colorText: Colors.white,
      duration: Duration(
        milliseconds:
            message.length < 24 ? 2000 : (message.length ~/ 24) * 1200,
      ),
    );
  }
}
