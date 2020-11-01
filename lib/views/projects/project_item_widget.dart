import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:videotor/data/entities/index.dart';
import 'package:videotor/helpers/index.dart';
import 'package:easy_localization/easy_localization.dart';

class ProjectItemWidget extends StatelessWidget {
  final VideoProject videoProject;

  ProjectItemWidget(this.videoProject);
  final outlineTextStyle = ([bool darkColorSwitch = true]) => TextStyle(
        color: Constants.darkColorSwitch(darkColorSwitch),
        fontWeight: FontWeight.bold,
        shadows: [
          BoxShadow(
            color: Constants.darkColorSwitch(!darkColorSwitch),
            offset: Offset(1, 1),
            spreadRadius: 3,
          )
        ],
      );
  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey(videoProject.id),
      child: Card(
        color: Constants.labelColor,
        margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(9.0)),
          side: BorderSide(
            color: Constants.backgroundColor,
            width: 1.0,
          ),
        ),
        child: Container(
          height: 91,
          child: Stack(
            children: [
              Obx(() => videoProject.thumbnail),
              Positioned(
                top: 12,
                right: 14,
                child: Obx(() => Text(
                      DateFormat(
                        'd MMMM yyyy HH:mm',
                        EasyLocalization.of(context).locale.toString(),
                      ).format(videoProject.buildDate.value.toDateTime()),
                      style: outlineTextStyle(videoProject.videoItems.isEmpty)
                          .copyWith(fontSize: 11),
                    )),
              ),
              Positioned(
                top: 29,
                right: 0,
                left: 0,
                child: Obx(() => Text(
                      videoProject.title.value.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: outlineTextStyle()
                          .copyWith(color: Constants.intenseColor),
                    )),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      child: Obx(() => Text(
                            "label.open_project".tr().toUpperCase(),
                            style: outlineTextStyle(
                                videoProject.videoItems.isEmpty),
                          )),
                      onPressed: videoProject.openProject,
                    ),
                    TextButton(
                      child: Obx(() => Text(
                            "label.export_project".tr().toUpperCase(),
                            style: outlineTextStyle(
                                videoProject.videoItems.isEmpty),
                          )),
                      onPressed: () {},
                    ),
                    TextButton(
                      child: Obx(() => Text(
                            "label.delete_project".tr().toUpperCase(),
                            style: outlineTextStyle(
                                videoProject.videoItems.isEmpty),
                          )),
                      onPressed: videoProject.removeProject,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
