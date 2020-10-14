import 'package:get/get.dart' hide Trans;
import 'package:videotor/entities/index.dart';
import 'package:videotor/metadata/index.dart';
import 'package:videotor/services/dataService.dart';
import 'package:videotor/services/index.dart';

class VideoItem extends GenericEntity<VideoItem> {
  var begin = 0.0.obs;
  var end = 0.0.obs;

  var isPlaying = false.obs;

  Rx<User> user = Rx<User>();

  @override
  String toString() => isPlaying.value ? "Çalıyor" : "Çalmıyor";

  @override
  TableInfo<VideoItem> get tableInfo => TableInfo<VideoItem>(
        version: 1,
        tableName: "video_items",
        resource: "video-items",
        translation: "entity.video_items",
        fieldInfos: [
          FieldInfo(
            name: "begin",
            repr: "Başlangıç",
            dataType: DataType.int,
            prop: Prop(
              getter: (e) => e.begin.value,
              setter: (e, val) => e.begin.value = val,
            ),
          ),
          FieldInfo(
            name: "end",
            repr: "Bitiş",
            dataType: DataType.int,
            prop: Prop(
              getter: (e) => e.end.value,
              setter: (e, val) => e.end.value = val,
            ),
          ),
        ],
        referenceInfos: [
          ReferenceInfo(
            referenceRepo: DataService.repositoryOf<User>(),
            referencingColumn: "user_id",
          ),
        ],
      );

  @override
  int get hashCode =>
      begin.hashCode ^
      end.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideoItem &&
          begin == other.begin &&
          end == other.end;
}
