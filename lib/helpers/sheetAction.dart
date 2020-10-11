import 'package:flutter/material.dart';

class SheetAction {
  final String title;
  final String subtitle;
  final Color color;
  final String response;
  final Function() onPress;
  final bool isDefault;
  final bool isCancelButton;

  SheetAction({
    @required this.title,
    this.subtitle,
    this.color,
    this.response,
    this.onPress,
    this.isDefault: false,
    this.isCancelButton: false,
  });
}
