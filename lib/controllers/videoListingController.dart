import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
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

  Future<void> addAssets() async {
    final videos = await _pickVideos();
    for (var video in videos) {
      final newPath = await _saveAsset(video);
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

  Future<String> _saveAsset(File video) async {
    final appDir = await getApplicationDocumentsDirectory();
    final newDir = Directory("${appDir.path}/videos/raw");
    if (!newDir.existsSync()) {
      await newDir.create(recursive: true);
    }
    final newPath = "${newDir.path}/${basename(video.path)}";
    final mediaFile = File(newPath);
    if (mediaFile.existsSync()) {
      await mediaFile.delete();
    }
    await video.copy(newPath);
    return newPath;
  }

  Future<List<File>> _pickVideos() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.video,
      );
      final files = result.paths.map((path) => File(path)).toList();
      return files;
    } on Exception {
      return <File>[];
    }
  }
}
