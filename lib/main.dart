import 'package:flutter/widgets.dart';
import 'package:videotor/helpers/index.dart';
import 'package:videotor/services/startup.dart' as startup;
import 'package:easy_localization/easy_localization.dart';
import 'package:videotor/tabs/home/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await startup.init();
  runApp(
    EasyLocalization(
      supportedLocales: [AppLocales[AppLocale.tr], AppLocales[AppLocale.en]],
      path: 'assets/translations', // <-- change patch to your
      fallbackLocale: AppLocales[AppLocale.en],
      startLocale: AppLocales[AppLocale.tr],
      child: Home(),
    ),
  );
}
