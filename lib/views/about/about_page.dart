import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:videotor/helpers/index.dart';
import 'package:videotor/views/index.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';

class AboutPage extends AppPage {
  @override
  get translationKey => 'title.about_page'.obs;

  @override
  get icon => Icon(Icons.account_box).obs;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Align(
          alignment: Alignment.center,
          child: Container(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'app_name'.tr().toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 11.0),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 21.0),
                    child: Text(
                      'title.about_app',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: vividTitleColor),
                    ).tr(),
                  ),
                  SizedBox(height: 11.0),
                  Text(
                    'text.about_app',
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                    textAlign: TextAlign.justify,
                  ).tr()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
