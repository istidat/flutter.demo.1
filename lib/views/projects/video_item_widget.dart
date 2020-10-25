import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:videotor/components/index.dart';
import 'package:videotor/data/entities/index.dart';
import 'package:videotor/helpers/index.dart';

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
      child: Row(
        children: [
          Expanded(
            flex: 9,
            child: InkWell(
              child: _buildCard(),
              onTap: videoItem.videoEditor,
            ),
          ),
          Expanded(child: _buildTrailing()),
        ],
      ),
    );
  }

  Card _buildCard() {
    final double cardHeight = 81;
    return Card(
      child: Obx(() => !videoItem.persisted.value
          ? Container(
              height: cardHeight,
              child: Center(child: CircularProgressIndicator()),
            )
          : Container(
              height: cardHeight,
              child: Stack(
                children: [
                  Obx(() => Padding(
                        padding: EdgeInsets.all(1),
                        child: videoItem.thumbnail.value,
                      )),
                  Positioned(
                    bottom: 3,
                    left: 5,
                    child: Obx(() => Text(
                          videoItem.videoInfo.value.duration.toHHMMSS(),
                        )),
                  ),
                ],
              ),
            )),
    );
  }

  Widget _buildTrailing() {
    return Padding(
      padding: EdgeInsets.only(right: 5),
      child: PopupMenuButton<ThreeDotMenuAction>(
        padding: EdgeInsets.all(0),
        icon: Icon(Icons.more_vert, color: Colors.white),
        onSelected: (term) async {
          switch (term) {
            case ThreeDotMenuAction.edit:
              break;
            case ThreeDotMenuAction.delete:
              await videoItem.deleteVideo();
              break;
            default:
              break;
          }
        },
        itemBuilder: (context) {
          return [
            ThreeDotMenuAction.edit,
            ThreeDotMenuAction.delete,
          ].menuItems;
        },
      ),
    );
  }
}
