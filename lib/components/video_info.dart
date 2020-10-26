import 'package:flutter/foundation.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:get/get.dart';

class VideoInfo {
  Duration duration;
  int width;
  int height;
  String fileName;
  static final FlutterFFprobe _ffprobe = new FlutterFFprobe();

  static Future<VideoInfo> _generate(String path) async {
    final vi = VideoInfo();
    if (path == null) {
      _default(vi);
    } else {
      final info = await _ffprobe.getMediaInformation(path);
      final mediaProps = info.getMediaProperties();
      if (mediaProps == null) {
        _default(vi);
      } else {
        vi.duration = Duration(
            seconds: double.parse(mediaProps['duration'].toString()).floor());
        vi.fileName = mediaProps['filename'].toString();
        final streams = info.getStreams();
        if (streams != null) {
          final props1 = streams.elementAt(0).getAllProperties();
          final props2 = streams.elementAt(1).getAllProperties();
          vi.width = props1['width'] ?? props2['width'];
          vi.height = props1['height'] ?? props2['height'];
        }
      }
    }
    return vi;
  }

  static void _default(VideoInfo vi) {
    vi.duration = Duration(seconds: 0);
    vi.width = Get.context.mediaQueryShortestSide.toInt();
    vi.height = 81;
  }

  static Future<VideoInfo> of({@required String path}) async {
    return await _generate(path);
  }
}
