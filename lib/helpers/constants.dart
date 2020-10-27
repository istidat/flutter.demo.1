import 'package:flutter/material.dart';

Color vividTitleColor = Colors.grey[900];
Color vividButtonColor = Colors.amber[900];

class Constants {
  static const Color darkColor = const Color(0xFF1E2E44);
  static const Color lightColor = const Color(0xFF57B1F5);
  static const Color intenseColor = Colors.blue;
  static const Color notrColor = const Color(0xFFECECEC);
  static const Color labelColor = notrColor;
  static const Color backgroundColor = darkColor;
  static const Color buttonColor = notrColor;
  static Color darkColorSwitch(bool onOff) {
    return onOff ? darkColor : notrColor;
  }
}

const bir_yil_premium = 'bir_yil_premium';
