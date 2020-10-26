import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:video_trimmer/video_trimmer.dart';
import 'package:videotor/components/index.dart';
import 'package:videotor/data/entities/index.dart';
import 'package:videotor/helpers/index.dart';
import 'package:videotor/data/metadata/index.dart';
import 'package:videotor/services/dataService.dart';
import 'package:videotor/services/index.dart';
import 'package:videotor/views/projects/index.dart';

enum EditorPurpose {
  forSpliceEqual,
}

class VideoItem extends GenericEntity<VideoItem> {
  var begin = 0.0.obs;
  var end = 0.0.obs;
  var path = "".obs;
  VideoProject get project => owner as VideoProject;

  var isPlaying = false.obs;
  var persisted = false.obs;
  final trimmer = Trimmer();
  Rx<Widget> thumbnail = Rx<Widget>();
  Rx<VideoInfo> videoInfo = Rx<VideoInfo>();

  Future<void> loadThumbnail() async {
    if (persisted.value) {
      return;
    }
    final video = File(path.value);
    final info = await this.info();
    if (video.existsSync()) {
      final thumbData = await VideoThumbnail.thumbnailData(
        video: video.path,
        imageFormat: ImageFormat.PNG,
        maxWidth: Get.context.mediaQueryShortestSide.toInt(),
        quality: 100,
      );
      thumbnail.value = Image.memory(
        thumbData,
        fit: BoxFit.cover,
        width: Get.context.mediaQueryShortestSide,
      );
    } else {
      thumbnail.value = Image.asset(
        'assets/images/widgets/video.png',
        fit: BoxFit.cover,
        width: Get.context.mediaQueryShortestSide,
      );
    }
    videoInfo.value = info;
    await saveVideo(firstTime: true);
    persisted.value = true;
  }

  Future<VideoInfo> info() async {
    if (File(path.value).existsSync()) {
      return await VideoInfo.of(path: path.value);
    } else {
      return VideoInfo();
    }
  }

  Future<void> deleteVideo() async {
    final video = File(this.path.value);
    if (video.existsSync()) {
      await video.delete();
    }
    final videoProject = this.owner as VideoProject;
    videoProject.videoItems.remove(this);
    await DataService.repositoryOf<VideoItem>().delete(this);
  }

  Future<void> videoEditor(
      {EditorPurpose purpose: EditorPurpose.forSpliceEqual}) async {
    final file = File(path.value);
    if (file.existsSync()) {
      try {
        await trimmer.loadVideo(videoFile: file);
      } on Exception {
        return;
      }
      Get.to(TrimmerView(this, purpose));
    } else {
      await UIHelper.alert(
        title: "alert.warning",
        message: "alert.error_occurred",
        multipleChoice: false,
      );
    }
  }

  Future<void> saveVideo(
      {double begin: -1, double end: -1, bool firstTime: false}) async {
    if (firstTime) {
      try {
        await trimmer.loadVideo(videoFile: File(path.value));
      } on Exception {
        return;
      }
      this.begin.value = 0.0;
      this.end.value = videoInfo.value.duration.inMilliseconds.toDouble();
    }
    path.value = await trimmer.saveTrimmedVideo(
      startValue: firstTime || begin == -1 ? this.begin.value : begin,
      endValue: firstTime || end == -1 ? this.end.value : end,
    );
    if (firstTime) {
      DataService.repositoryOf<VideoItem>().update(this);
    }
  }

  @override
  String toString() => isPlaying.value ? "Çalıyor" : "Çalmıyor";

  @override
  TableInfo<VideoItem> get tableInfo => TableInfo<VideoItem>(
        version: 1,
        tableName: "video_items",
        resource: "video-items",
        translation: "entity.video_item",
        fieldInfos: [
          FieldInfo(
            name: "begin",
            translation: "entity.video_item.begin",
            dataType: DataType.real,
            prop: Prop(
              getter: (e) => e.begin.value,
              setter: (e, val) => e.begin.value = val,
            ),
          ),
          FieldInfo(
            name: "end",
            translation: "entity.video_item.end",
            dataType: DataType.real,
            prop: Prop(
              getter: (e) => e.end.value,
              setter: (e, val) => e.end.value = val,
            ),
          ),
          FieldInfo(
            name: "path",
            translation: "entity.video_item.path",
            dataType: DataType.int,
            displayOnForm: false,
            prop: Prop(
              getter: (e) => e.path.value,
              setter: (e, val) => e.path.value = val,
            ),
          ),
        ],
        referenceInfos: [
          ReferenceInfo(
            referenceRepo: DataService.repositoryOf<VideoProject>(),
            referencingColumn: "video_project_id",
          ),
        ],
      );

  @override
  int get hashCode => begin.hashCode ^ end.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideoItem && begin == other.begin && end == other.end;
}
