import 'dart:io';

import 'package:get/get.dart' hide Trans;
import 'package:image_picker/image_picker.dart';
import 'package:video_trimmer/video_trimmer.dart';
import 'package:videotor/entities/index.dart';
import 'package:videotor/metadata/index.dart';
import 'package:videotor/services/dataService.dart';
import 'package:videotor/services/index.dart';

class VideoItem extends GenericEntity<VideoItem> {
  var begin = 0.0.obs;
  var end = 0.0.obs;
  var path = "".obs;
  VideoProject get project => owner as VideoProject;

  var isPlaying = false.obs;
  var saved = false.obs;
  var loaded = false.obs;
  bool get visible => loaded.value && saved.value;
  Trimmer trimmer = Trimmer();

  Future<VideoItem> withSampleOf(String filePath) async {
    path.value = filePath;
    await loadVideoFile(withSamplePath: filePath);
    return this;
  }

  Future<void> loadVideoFile({String withSamplePath}) async {
    File pickedFile;
    if (withSamplePath != null) {
      pickedFile = File(withSamplePath);
    } else {
      var picked = await ImagePicker().getVideo(
        source: ImageSource.gallery,
      );
      pickedFile = File(picked.path);
    }
    if (pickedFile.existsSync()) {
      await trimmer.loadVideo(videoFile: pickedFile);
      loaded.value = true;
    } else {
      loaded.value = false;
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
            dataType: DataType.int,
            prop: Prop(
              getter: (e) => e.begin.value,
              setter: (e, val) => e.begin.value = val,
            ),
          ),
          FieldInfo(
            name: "end",
            translation: "entity.video_item.end",
            dataType: DataType.int,
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
