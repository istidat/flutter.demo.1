import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:videotor/controllers/index.dart';
import 'package:videotor/tabs/app_page.dart';
import 'package:videotor/tabs/projects/index.dart';

class ProjectListingPage extends AppPage<ProjectListingController> {
  @override
  get translationKey => "tab.video_projects".obs;

  @override
  get floatingButton => FloatingActionButton(
        elevation: 16.0,
        backgroundColor: Colors.redAccent,
        child: Icon(Icons.add, color: Colors.white),
        onPressed: controller.addVideoProject,
      ).obs;

  @override
  get icon => FaIcon(FontAwesomeIcons.video).obs;

  @override
  Widget build(BuildContext context) {
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
