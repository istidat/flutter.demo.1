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
        color: Constants.labelColor,
        textStyle: TextStyle(fontSize: 15),
      ),
      bodyText1: GoogleFonts.openSans(
        textStyle: TextStyle(color: Constants.labelColor),
      ),
      bodyText2: GoogleFonts.openSans(
        textStyle: TextStyle(color: Constants.labelColor),
      ),
      headline6: GoogleFonts.openSans(
        textStyle: TextStyle(color: Constants.labelColor),
      ),
    );
    return GetMaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: 'OpenSans',
          brightness: Brightness.light,
          primarySwatch: Constants.primaryColor.material,
          appBarTheme: AppBarTheme(
            textTheme: customFontTextTheme,
            iconTheme: IconThemeData(color: Constants.buttonColor),
            actionsIconTheme: IconThemeData(color: Constants.buttonColor),
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
            'assets/images/widgets/screen.png',
            fit: BoxFit.fill,
          ),
        ],
      ),
    );
  }
}
