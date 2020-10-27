import 'package:get/get.dart' hide Trans;
import 'package:videotor/data/entities/index.dart';
import 'package:videotor/services/index.dart';
import 'package:easy_localization/easy_localization.dart';

class ProjectListingController extends GetxController {
  RxList<VideoProject> videoProjects = Get.find<User>().videoProjects;

  void addVideoProject() async {
    final today = DateFormat(
      'd.M.y HH:mm:ss',
      EasyLocalization.of(Get.context).locale.toString(),
    ).format(DateTime.now());
    final projectTitle = "default.project_title".tr(args: [today]);
    final VideoProject inserted =
        await DataService.repositoryOf<VideoProject>().insert(
      VideoProject()
        ..title.value = projectTitle
        ..owner = Get.find<User>(),
    );
    if (inserted != null) {
      videoProjects.add(inserted);
    }
  }

  void loadAllThumbnails() {
    this.videoProjects.forEach((vp) {
      vp.videoItems.forEach((vi) async => vi.loadThumbnail());
    });
  }
}
