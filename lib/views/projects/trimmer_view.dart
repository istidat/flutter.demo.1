import 'package:flutter/material.dart';
import 'package:video_trimmer/video_trimmer.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:videotor/data/entities/index.dart';
import 'package:videotor/helpers/index.dart';
import 'package:videotor/views/app_page.dart';

class TrimmerView extends AppPage<User> {
  final VideoItem videoItem;
  final EditorPurpose editorPurpose;
  TrimmerView(this.videoItem, this.editorPurpose);

  @override
  get translationKey => 'title.video_trim_page'.obs;

  @override
  RxList<Widget> get actions => <Widget>[
        FlatButton(
          onPressed: videoItem.saved.value
              ? null
              : () async {
                  videoItem.saveVideo().then((value) {
                    UIHelper.snack(
                      title: 'title.process_completed'.tr(),
                      message: 'message.video_save_success'.tr(),
                    );
                  });
                },
          child: Text('label.save_video').tr(),
        )
      ].obs;

  @override
  Widget build(BuildContext context) {
    return super.buildThe(Container(
      child: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Obx(() => Visibility(
                    visible: videoItem.loaded.value,
                    replacement: CircularProgressIndicator(),
                    child: Expanded(
                      child: VideoViewer(borderColor: Colors.white),
                    ),
                  )),
              Center(
                child: TrimEditor(
                  viewerHeight: 50.0,
                  viewerWidth: MediaQuery.of(context).size.width * 0.95,
                  onChangeStart: (value) {
                    videoItem.begin.value = value;
                  },
                  onChangeEnd: (value) {
                    videoItem.end.value = value;
                  },
                  onChangePlaybackState: (value) {
                    videoItem.isPlaying.value = value;
                  },
                ),
              ),
              Obx(() => FlatButton(
                    child: videoItem.isPlaying.value
                        ? Icon(
                            Icons.pause,
                            size: 80.0,
                            color: Colors.white,
                          )
                        : Icon(
                            Icons.play_arrow,
                            size: 80.0,
                            color: Colors.white,
                          ),
                    onPressed: () async {
                      videoItem.isPlaying.value =
                          await videoItem.trimmer.videPlaybackControl(
                        startValue: videoItem.begin.value,
                        endValue: videoItem.end.value,
                      );
                    },
                  ))
            ],
          ),
        ),
      ),
    ));
  }
}
