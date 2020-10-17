import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_trimmer/video_trimmer.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:videotor/entities/index.dart';
import 'package:videotor/helpers/index.dart';
import 'package:videotor/tabs/app_page.dart';

class VideoTrimmer extends AppPage<VideoItem> {
  final Trimmer _trimmer = Trimmer();

  @override
  get translationKey => 'title.video_trim_page'.obs;

  @override
  get icon => FaIcon(FontAwesomeIcons.videoSlash).obs;

  @override
  get actions => <Widget>[
        FlatButton.icon(
          onPressed: () async {
            var picked = await ImagePicker().getVideo(
              source: ImageSource.gallery,
            );
            var pickedFile = File(picked.path);
            if (pickedFile.existsSync()) {
              await _trimmer.loadVideo(videoFile: pickedFile);
              controller.saved.value = true;
            } else {
              controller.saved.value = false;
            }
          },
          icon: FaIcon(FontAwesomeIcons.fileVideo),
          label: Text("label.load_video").tr(),
        )
      ].obs;

  Future<void> _saveVideo() async {
    controller.loaded.value = false;
    controller.path.value = await _trimmer.saveTrimmedVideo(
      startValue: controller.begin.value,
      endValue: controller.end.value,
    );
    controller.loaded.value = true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Container(
          padding: EdgeInsets.only(bottom: 30.0),
          color: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Visibility(
                  visible: controller.visible,
                  child: CircularProgressIndicator()),
              RaisedButton(
                onPressed: controller.saved.value
                    ? null
                    : () async {
                        _saveVideo().then((value) {
                          UIHelper.snack(
                            title: 'title.process_completed'.tr(),
                            message: 'message.video_save_success'.tr(),
                          );
                        });
                      },
                child: Text('label.save_video').tr(),
              ),
              Expanded(
                child: VideoViewer(),
              ),
              Center(
                child: TrimEditor(
                  viewerHeight: 50.0,
                  viewerWidth: MediaQuery.of(context).size.width,
                  onChangeStart: (value) {
                    controller.begin.value = value;
                  },
                  onChangeEnd: (value) {
                    controller.end.value = value;
                  },
                  onChangePlaybackState: (value) {
                    controller.isPlaying.value = value;
                  },
                ),
              ),
              FlatButton(
                child: controller.isPlaying.value
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
                  controller.isPlaying.value =
                      await _trimmer.videPlaybackControl(
                    startValue: controller.begin.value,
                    endValue: controller.end.value,
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
