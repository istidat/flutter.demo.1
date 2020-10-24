import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:videotor/components/forms/index.dart';
import 'package:videotor/entities/index.dart';
import 'package:videotor/services/index.dart';

class VideoProjectsController extends GetxController {
  RxList<VideoProject> videoProjects = Get.find<User>().videoProjects;
  void addVideoProject() async {
    final VideoProject formed = await Get.to(
      InsertForm.of<VideoProject>(GlobalKey()),
      fullscreenDialog: true,
    );
    final VideoProject inserted = await DataService.repositoryOf<VideoProject>()
        .insert(formed..owner = Get.find<User>());
    videoProjects.add(inserted);
  }
}
