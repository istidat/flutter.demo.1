import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:videotor/data/entities/index.dart';
import 'package:videotor/helpers/index.dart';
import 'package:videotor/data/metadata/index.dart';
import 'package:videotor/services/dataService.dart';
import 'package:videotor/services/index.dart';
import 'package:videotor/views/projects/index.dart';

class VideoProject extends GenericEntity<VideoProject> {
  var title = "".obs;
  var buildDate = "".obs;

  User get user => owner as User;
  var videoItems = <VideoItem>[].obs;

  void openProject() {
    Get.to(VideoListingPage.of(this));
  }

  Widget get thumbnail {
    return Image.asset(
      'assets/images/widgets/project-thumbnail.png',
      fit: BoxFit.fill,
    );
  }

  Future<void> removeProject() async {
    UIHelper.alert(
      title: "title.are_you_sure",
      message: "message.video_project_will_remove",
      onApproval: () async {
        this.videoItems.forEach((vi) async => await vi.deleteVideo());
        user.videoProjects.remove(this);
        await DataService.repositoryOf<VideoProject>().delete(this);
      },
    );
  }

  @override
  TableInfo<VideoProject> get tableInfo => TableInfo<VideoProject>(
        version: 1,
        tableName: "video_projects",
        resource: "video-projects",
        translation: "entity.video_project",
        fieldInfos: [
          FieldInfo(
            name: "title",
            translation: "entity.video_project.title",
            prop: Prop(
              getter: (e) => e.title.value,
              setter: (e, val) => e.title.value = val,
            ),
          ),
          FieldInfo(
            name: "buildDate",
            translation: "entity.video_project.buildDate",
            displayOnForm: false,
            prop: Prop(
              getter: (e) => e.buildDate.value,
              setter: (e, val) => e.buildDate.value = val,
              defaultValueGetter: (e) => DateTime.now().toString(),
            ),
          ),
        ],
        collectionInfos: [
          CollectionInfo(
            name: "videoItems",
            collectionProp: CollectionProp(
              getter: (e) => e.videoItems,
              setter: (v, items) =>
                  v..videoItems.value = items.cast<VideoItem>().toList(),
              itemRepo: DataService.repositoryOf<VideoItem>(),
            ),
          )
        ],
        referenceInfos: [
          ReferenceInfo(
            referenceRepo: DataService.repositoryOf<User>(),
            referencingColumn: "user_id",
          ),
        ],
      );

  @override
  int get hashCode => title.hashCode ^ buildDate.hashCode ^ thumbnail.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideoProject &&
          title == other.title &&
          buildDate == other.buildDate &&
          thumbnail == other.thumbnail;
}
