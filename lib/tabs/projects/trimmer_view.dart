import 'package:flutter/material.dart';
import 'package:video_trimmer/video_trimmer.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:videotor/entities/index.dart';
import 'package:videotor/helpers/index.dart';
import 'package:videotor/tabs/app_page.dart';

class TrimmerView extends AppPage<User> {
  final VideoItem videoItem;
  TrimmerView(this.videoItem);

  @override
  get translationKey => 'title.video_trim_page'.obs;

  @override
  get icon => FaIcon(FontAwesomeIcons.videoSlash).obs;

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
                visible: videoItem.visible,
                child: CircularProgressIndicator(),
              ),
              RaisedButton(
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
              ),
              Expanded(
                child: VideoViewer(),
              ),
              Center(
                child: TrimEditor(
                  viewerHeight: 50.0,
                  viewerWidth: MediaQuery.of(context).size.width,
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
              FlatButton(
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
