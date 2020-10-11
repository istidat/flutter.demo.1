import 'package:flutter/material.dart';

enum AppLocale { tr, en }

const AppLocales = {
  AppLocale.tr: Locale('tr', 'TR'),
  AppLocale.en: Locale('en', 'US'),
};

extension AppLocaleExtensions on AppLocale {
  get repr {
    switch (this) {
      case AppLocale.tr:
        return "tr";
      case AppLocale.en:
        return "en";
    }
  }

  get language {
    switch (this) {
      case AppLocale.tr:
        return "Türkçe";
      case AppLocale.en:
        return "English";
    }
  }
}
