import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:flutter_ffmpeg/media_information.dart';
import 'package:get/get.dart' hide Trans;
import 'package:thumbnails/thumbnails.dart';
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

class VideoInfo {
  double duration;
  double width;
  double height;
  double bitrate;

  VideoInfo({MediaInformation info}) {
    final mediaProps = info.getMediaProperties();
    this.duration = double.parse(mediaProps['duration'].toString());
    final streams = info.getStreams();
    if (streams != null) {
      final props = streams.first.getAllProperties();
      this.width = double.parse(props['width'].toString());
      this.height = double.parse(props['height'].toString());
      this.bitrate = double.parse(props['bitrate'].toString());
    }
  }
}

class VideoItem extends GenericEntity<VideoItem> {
  var begin = 0.0.obs;
  var end = 0.0.obs;
  var path = "".obs;
  VideoProject get project => owner as VideoProject;

  var isPlaying = false.obs;
  var saved = false.obs;
  var loaded = false.obs;
  final trimmer = Trimmer();
  final FlutterFFprobe _ffprobe = new FlutterFFprobe();

  Future<Widget> thumbnail() async {
    final video = File(path.value);
    if (video.existsSync()) {
      final info = await this.info();
      final w = info.width;
      final h = info.height;
      final int maxWidth = (Get.context.mediaQuery.size.width * .9).floor();
      final int maxHeight = ((h / w) * maxWidth).floor();
      final thumbFile = await Thumbnails.getThumbnail(
        thumbnailFolder: video.parentDirectory.path,
        videoFile: video.path,
        imageType: ThumbFormat.PNG,
        quality: 80,
      );
      return Image.memory(
        File(thumbFile).readAsBytesSync(),
        fit: BoxFit.cover,
        width: maxWidth.toDouble(),
        height: maxHeight.toDouble(),
      );
    } else {
      return Image.asset(
        'assets/images/widgets/video-thumbnail.png',
        fit: BoxFit.fill,
      );
    }
  }

  Future<VideoInfo> info() async {
    if (File(path.value).existsSync()) {
      return VideoInfo(info: await _ffprobe.getMediaInformation(path.value));
    } else {
      return VideoInfo();
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
