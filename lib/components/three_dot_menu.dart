import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:videotor/helpers/index.dart';

enum ThreeDotMenuAction {
  edit,
  reset,
  delete,
}

extension TDMExtension on ThreeDotMenuAction {
  get string {
    switch (this) {
      case ThreeDotMenuAction.edit:
        return "tdm_edit".tr();
      case ThreeDotMenuAction.reset:
        return "tdm_reset".tr();
      case ThreeDotMenuAction.delete:
        return "tdm_delete".tr();
    }
  }

  get item {
    switch (this) {
      case ThreeDotMenuAction.edit:
        return Row(
          children: [
            Icon(
              Icons.edit,
              color: vividTitleColor,
            ),
            Text(" "),
            Text(string),
          ],
        );
      case ThreeDotMenuAction.reset:
        return Row(
          children: [
            Icon(
              Icons.refresh,
              color: vividTitleColor,
            ),
            Text(" "),
            Text(string),
          ],
        );
      case ThreeDotMenuAction.delete:
        return Row(
          children: [
            Icon(
              Icons.delete,
              color: vividTitleColor,
            ),
            Text(" "),
            Text(string),
          ],
        );
    }
  }
}

extension TDMListExtension on List<ThreeDotMenuAction> {
  get menuItems =>
      this.map((tdm) => PopupMenuItem(value: tdm, child: tdm.item)).toList();
}
