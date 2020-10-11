import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart' hide Trans;
import 'package:google_fonts/google_fonts.dart';
import 'package:videotor/controllers/index.dart';
import 'package:videotor/helpers/index.dart';

class Home extends GetView<HomeController> {
  @override
  Widget build(context) {
    controller.setParams(0);
    controller.loadPremium();
    final customFontTextTheme =
        GoogleFonts.openSansTextTheme(Theme.of(context).textTheme).copyWith(
      button: GoogleFonts.openSans(
        color: vividTitleColor,
        textStyle: TextStyle(color: vividTitleColor, fontSize: 15),
      ),
      bodyText1: GoogleFonts.openSans(
        textStyle: TextStyle(color: vividTitleColor),
      ),
      bodyText2: GoogleFonts.openSans(
        textStyle: TextStyle(color: vividTitleColor),
      ),
      headline6: GoogleFonts.openSans(
        textStyle: TextStyle(color: vividTitleColor),
      ),
    );
    return GetMaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: 'OpenSans',
          brightness: Brightness.dark,
          primarySwatch: Colors.grey,
          appBarTheme: AppBarTheme(
            textTheme: customFontTextTheme,
            iconTheme: IconThemeData(color: vividTitleColor),
            actionsIconTheme: IconThemeData(color: vividTitleColor),
          ),
          primaryTextTheme: customFontTextTheme),
      home: Obx(() => Scaffold(
            appBar: controller.appBar.value,
            floatingActionButton: controller.floatingButton.value != null
                ? Obx(() => Padding(
                      padding: EdgeInsets.only(
                        bottom: controller.fabElevation.value,
                      ),
                      child: controller.floatingButton.value,
                    ))
                : null,
            drawer: _buildDrawer(context),
            body: SafeArea(child: controller.pages[controller.pageIndex.value]),
            bottomNavigationBar: controller.bottomNavigationBar,
          )),
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Image.asset(
            'assets/images/resources/zakiriyn-screen.png',
            fit: BoxFit.fill,
          ),
        ],
      ),
    );
  }
}
