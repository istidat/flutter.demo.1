import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:videotor/components/forms/options_form.dart';

class ColorModel implements OptionForm {
  final Color color;

  @override
  get item => this.color;

  static var models = [
    Colors.orange[500],
    Colors.blue,
    Colors.cyan,
    Colors.deepOrange,
    Colors.deepOrangeAccent,
    Colors.deepPurpleAccent,
    Colors.green,
    Colors.lightBlue,
    Colors.teal
  ].map((c) => ColorModel(c)).toList();

  ColorModel(this.color);

  @override
  Widget get subtitle => Text("title.change_color").tr();

  @override
  Widget get title => Text(
        "title.dhikr_color_will_be_changed_to",
        style: TextStyle(color: color),
      ).tr();
}
