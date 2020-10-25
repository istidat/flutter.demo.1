import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:media_info/media_info.dart';
import 'package:video_trimmer/video_trimmer.dart';
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
  var saved = false.obs;
  var loaded = false.obs;
  Future<bool> get isVideoFile async =>
      (await info())['mimeType'].startsWith("video/");
  final trimmer = Trimmer();
  final MediaInfo _mediaInfo = MediaInfo();

  Future<Widget> thumbnail(double maxHeight) async {
    if (File(path.value).existsSync()) {
      final info = await this.info();
      final int w = info['width'];
      final int h = info['height'];
      final int maxWidth = ((w / h) * maxHeight).floor();
      print(path.value.thumbnailPath);
      final thumbFile = await _mediaInfo.generateThumbnail(
        path.value,
        path.value.thumbnailPath,
        maxWidth,
        maxHeight.floor(),
      );
      return Image.file(File(thumbFile));
    } else {
      return Image.asset(
        'assets/images/widgets/video-thumbnail.png',
        fit: BoxFit.fill,
      );
    }
  }

  Future<Map<String, dynamic>> info() async {
    if (File(path.value).existsSync()) {
      final Map<String, dynamic> mediaInfo =
          await _mediaInfo.getMediaInfo(path.value);
      return mediaInfo;
    } else {
      return null;
    }
  }

  Future<void> deleteVideo() async {
    final videoProject = this.owner as VideoProject;
    videoProject.videoItems.remove(this);
    await DataService.repositoryOf<VideoItem>().delete(this);
  }

  Future<void> videoEditor(
      {EditorPurpose purpose: EditorPurpose.forSpliceEqual}) async {
    final file = File(path.value);
    loaded.value = await file.exists();
    if (loaded.value) {
      await trimmer.loadVideo(videoFile: file);
      Get.to(TrimmerView(this, purpose));
    } else {
      await UIHelper.alert(
        title: "alert.warning",
        message: "alert.error_occurred",
        multipleChoice: false,
      );
    }
  }

  Future<void> saveVideo() async {
    loaded.value = false;
    path.value = await trimmer.saveTrimmedVideo(
      startValue: begin.value,
      endValue: end.value,
    );
    saved.value = true;
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
