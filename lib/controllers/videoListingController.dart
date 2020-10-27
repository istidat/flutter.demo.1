import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:videotor/data/entities/index.dart';
import 'package:videotor/services/index.dart';
import 'package:path/path.dart';

class VideoListingController extends GetxController {
  VideoProject videoProject;

  void setProject(VideoProject videoProject) {
    this.videoProject = videoProject
      ..videoItems.forEach((vi) async => await vi.loadThumbnail());
  }

  Future<void> addVideoItem({ImageSource from: ImageSource.gallery}) async {
    final pickedFile = await pickVideoFile(from);
    if (pickedFile != null) {
      final newPath = await saveVideo(pickedFile.path);
      final formed = VideoItem()
        ..path.value = newPath
        ..persisted.value = 1
        ..owner = this.videoProject;
      final VideoItem inserted =
          await DataService.repositoryOf<VideoItem>().insert(formed);
      if (inserted != null) {
        this.videoProject.videoItems.add(inserted..loadThumbnail());
      }
    }
  }

  Future<String> saveVideo(String path) async {
    final appDir = await getApplicationDocumentsDirectory();
    final newDir = Directory("${appDir.path}/videos/raw");
    if (!newDir.existsSync()) {
      await newDir.create(recursive: true);
    }
    final newPath = "${newDir.path}/${basename(path)}";
    File(path).copy(newPath);
    return newPath;
  }

  Future<PickedFile> pickVideoFile(ImageSource source) async {
    final picker = ImagePicker();
    return await picker.getVideo(source: source);
  }
}
