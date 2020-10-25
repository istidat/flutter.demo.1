import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:videotor/components/forms/index.dart';
import 'package:videotor/data/entities/index.dart';

class ProjectListingController extends GetxController {
  RxList<VideoProject> videoProjects = Get.find<User>().videoProjects;
  void addVideoProject() async {
    final VideoProject inserted = await Get.to(
      InsertForm.of<VideoProject>(GlobalKey(), withOwner: Get.find<User>()),
      fullscreenDialog: true,
    );
    if (inserted != null) {
      videoProjects.add(inserted);
    }
  }
}
