import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:videotor/controllers/index.dart';
import 'package:videotor/data/entities/index.dart';
import 'package:videotor/views/app_page.dart';
import 'package:videotor/views/projects/index.dart';

class VideoItemListingPage extends AppPage<VideoItemListingController> {
  VideoItemListingPage(VideoProject videoProject) {
    controller.setProject(videoProject);
  }
  factory VideoItemListingPage.of(VideoProject videoProject) {
    return VideoItemListingPage(videoProject);
  }

  @override
  get translationKey => controller.videoProject.title;

  @override
  get floatingButton => buildSpeedDial().obs;

  @override
  get icon => FaIcon(FontAwesomeIcons.video).obs;

  @override
  Widget build(BuildContext context) {
    return super.buildThe(Center(
      child: Obx(() => controller.videoProject.videoItems.length == 0
          ? Center(
              child: Text("message.no_video_item").tr(),
            )
          : ListView.builder(
              itemCount: controller.videoProject.videoItems.length,
              itemBuilder: (ctx, index) =>
                  VideoItemWidget(controller.videoProject.videoItems[index]),
            )),
    ));
  }

  SpeedDial buildSpeedDial() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22.0),
      child: Icon(Icons.add, color: Colors.white),
      backgroundColor: Colors.redAccent,
      elevation: 16.0,
      visible: true,
      curve: Curves.bounceIn,
      overlayOpacity: 0.3,
      children: [
        SpeedDialChild(
          child: Icon(Icons.movie, color: Colors.white),
          backgroundColor: Colors.deepOrange,
          onTap: controller.addVideoItem,
          label: 'label.add_from_gallery'.tr(),
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.deepOrangeAccent,
        ),
        SpeedDialChild(
          child: Icon(Icons.camera, color: Colors.white),
          backgroundColor: Colors.green,
          onTap: () => controller.addVideoItem(from: ImageSource.camera),
          label: 'label.add_from_camera'.tr(),
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.green,
        ),
      ],
    );
  }
}
