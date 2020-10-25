import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:videotor/components/index.dart';
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
            child: InkWell(
              child: _buildCard(),
              onTap: videoItem.videoEditor,
            ),
          ),
          Expanded(
            child: _buildTrailing(),
          ),
        ],
      ),
    );
  }

  Card _buildCard() {
    final double cardHeight = 81;
    return Card(
      child: FutureBuilder<Widget>(
        future: videoItem.thumbnail(cardHeight),
        builder: (ctx, snapshot) {
          if (!snapshot.hasData) {
            return Container(
              height: cardHeight,
              child: Center(child: CircularProgressIndicator()),
            );
          } else {
            return Container(
              height: cardHeight,
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.all(1),
                    child: snapshot.data,
                  ),
                  FutureBuilder<Map<String, dynamic>>(
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
                                milliseconds:
                                    snapshot.data['durationMs'].toInt(),
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
      child: PopupMenuButton<ThreeDotMenuAction>(
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
          return [ThreeDotMenuAction.edit, ThreeDotMenuAction.delete].menuItems;
        },
      ),
    );
  }
}
