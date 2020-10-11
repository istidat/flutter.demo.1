import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:videotor/components/forms/options_form.dart';
import 'package:videotor/helpers/index.dart';

class LanguageModel implements OptionForm {
  @override
  get item => this.appLocale;

  final AppLocale appLocale;
  static final appLocaleOptions =
      AppLocales.keys.map((l) => LanguageModel(l)).toList();

  LanguageModel(this.appLocale);

  @override
  Widget get subtitle =>
      Text("title.change_system_language").tr(args: [this.appLocale.language]);

  @override
  Widget get title => Text(this.appLocale.language);
}
