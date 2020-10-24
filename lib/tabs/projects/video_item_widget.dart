import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:videotor/components/index.dart';
import 'package:videotor/entities/index.dart';
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
    return ListTile(
      key: ValueKey(videoItem.id),
      title: _buildCard(),
      trailing: _buildTrailing(),
      onTap: videoItem.tryVideoEditor,
    );
  }

  Card _buildCard() {
    return Card(
      color: Colors.white38.withOpacity(0.3),
      margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        side: BorderSide(
          color: Colors.white,
          width: 3.0,
        ),
      ),
      child: FutureBuilder<VideoPlayerController>(
        future: videoItem.controller,
        builder: (ctx, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            final _controller = snapshot.data;
            return Container(
              height: 72,
              child: Stack(
                children: [
                  videoItem.thumbnailOf(_controller),
                  Positioned(
                    bottom: 12,
                    right: 14,
                    child: Text(
                      _controller.value.duration.toHHMMSS(),
                      style: outlinedTextStyle,
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildTrailing() {
    return Row(
      children: [
        PopupMenuButton<ThreeDotMenuAction>(
          icon: Icon(Icons.more_vert, color: vividButtonColor),
          onSelected: (term) async {
            switch (term) {
              case ThreeDotMenuAction.delete:
                await videoItem.deleteVideo();
                break;
              default:
                break;
            }
          },
          itemBuilder: (context) {
            return [ThreeDotMenuAction.delete].menuItems;
          },
        ),
        Icon(Icons.arrow_forward_ios, color: Colors.white),
      ],
    );
  }
}
