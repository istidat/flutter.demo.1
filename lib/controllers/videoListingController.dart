import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:videotor/data/entities/index.dart';
import 'package:videotor/services/index.dart';

class VideoListingController extends GetxController {
  VideoProject videoProject;

  void setProject(VideoProject videoProject) {
    this.videoProject = videoProject
      ..videoItems.forEach((vi) => vi.loadThumbnail());
  }

  Future<void> addVideoItem({ImageSource from: ImageSource.gallery}) async {
    final pickedFile = await pickVideoFile(from);
    if (pickedFile != null) {
      final formed = VideoItem()
        ..path.value = pickedFile.path
        ..owner = this.videoProject;
      final VideoItem inserted =
          await DataService.repositoryOf<VideoItem>().insert(formed);
      if (inserted != null) {
        this.videoProject.videoItems.add(inserted..loadThumbnail());
      }
    }
  }

  Future<PickedFile> pickVideoFile(ImageSource source) async {
    final _picker = ImagePicker();
    final file = await _picker.getVideo(
        source: source, maxDuration: const Duration(seconds: 10));
    // _picker.getLostData()
    return file;
  }
}
