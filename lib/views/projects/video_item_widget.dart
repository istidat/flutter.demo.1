import 'package:flutter/material.dart';
import 'package:video_compress/video_compress.dart';
import 'package:videotor/data/entities/index.dart';
import 'package:videotor/helpers/index.dart';
import 'package:easy_localization/easy_localization.dart';

class VideoItemWidget extends StatelessWidget {
  final VideoItem videoItem;

  VideoItemWidget(this.videoItem);

  final outlinedTextStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    shadows: [
      BoxShadow(
        color: Colors.black,
        offset: Offset(1, 1),
        blurRadius: 3,
      )
    ],
  );
  @override
  Widget build(BuildContext context) {
    return Card(
      key: ValueKey(videoItem.id),
      color: Colors.black54.withOpacity(0.3),
      margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        side: BorderSide(
          color: vividButtonColor,
          width: 1.0,
        ),
      ),
      child: Flex(
        direction: Axis.horizontal,
        children: [
          Expanded(
            flex: 8,
            child: _buildCard(),
          ),
          Expanded(
            child: _buildTrailing(),
          ),
        ],
      ),
    );
  }

  Card _buildCard() {
    final double cardHeight = 72;
    return Card(
      child: FutureBuilder<Widget>(
        future: videoItem.thumbnail(cardHeight),
        builder: (ctx, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Container(
              height: cardHeight,
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.all(1),
                    child: snapshot.data,
                  ),
                  FutureBuilder<MediaInfo>(
                      future: videoItem.info(),
                      builder: (ctx, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          return Positioned(
                            bottom: 12,
                            right: 14,
                            child: Text(
                              Duration(
                                microseconds: snapshot.data.duration.toInt(),
                              ).toHHMMSS(),
                              style: outlinedTextStyle,
                            ),
                          );
                        }
                      }),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildTrailing() {
    return Container(
      padding: EdgeInsets.only(right: 5),
      child: IconButton(
        icon: Icon(Icons.more_vert),
        color: Colors.white,
        onPressed: () => _openBottomSheet(),
      ),
    );
  }

  _openBottomSheet() async {
    await UIHelper.actionSheet(
      title: "alert.continue_on_process".tr(),
      dismissible: true,
      actions: [
        SheetAction(
          title: "title.splice_equal".tr(),
          subtitle: "message.splice_equal".tr(),
          onPress: videoItem.videoEditor,
          color: Colors.green,
        ),
      ],
    );
  }
}
