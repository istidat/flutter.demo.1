import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:videotor/controllers/index.dart';
import 'package:videotor/helpers/index.dart';
import 'package:videotor/views/app_page.dart';
import 'package:videotor/views/projects/index.dart';

class ProjectListingPage extends AppPage<ProjectListingController> {
  @override
  get titleKey => "tab.video_projects".obs;

  @override
  get floatingButton => FloatingActionButton(
        elevation: 16.0,
        backgroundColor: Constants.backgroundColor,
        child: Icon(Icons.add, color: Constants.labelColor),
        onPressed: controller.addVideoProject,
      ).obs;

  @override
  get icon => FaIcon(FontAwesomeIcons.video).obs;

  @override
  Widget build(BuildContext context) {
    controller.loadAllThumbnails();
    return Center(
      child: Obx(() => controller.videoProjects.length == 0
          ? Center(
              child: Text("message.no_video_project").tr(),
            )
          : ListView(
              children: controller.videoProjects
                  .map((vp) => ProjectItemWidget(vp))
                  .toList(),
            )),
    );
  }
}
