import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart' hide Trans;
import 'package:videotor/controllers/index.dart';
import 'package:videotor/helpers/index.dart';
import 'package:videotor/tabs/app_page.dart';
import 'package:videotor/tabs/video_edit/index.dart';

class VideoPage extends AppPage<VideoPageController> {
  static const _kDuration = const Duration(milliseconds: 300);
  static const _kCurve = Curves.ease;

  final _controller = PageController(initialPage: 0);
  static RxList<Widget> pages = <Widget>[
    TrimmerPage(),
  ].obs;

  final Rx<AppPage> currentPage = (pages[0] as AppPage).obs;

  @override
  get translationKey => currentPage.value.translationKey;

  @override
  get actions => currentPage.value.actions;

  @override
  get floatingButton => FloatingActionButton(
        elevation: 16.0,
        backgroundColor: Colors.teal,
        child: Icon(Platform.isAndroid ? Icons.share_outlined : Icons.ios_share,
            color: Colors.white),
        onPressed: controller.share,
      ).obs;

  @override
  get icon => currentPage.value.icon;

  @override
  Widget build(BuildContext context) {
    setPage();
    return Center(
      child: Stack(
        children: <Widget>[
          PageView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            controller: _controller,
            itemCount: pages.length,
            itemBuilder: (BuildContext context, int index) {
              return pages[index];
            },
            onPageChanged: (index) {
              controller.currentIndex.value = index;
              setPage();
            },
          ),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              color: Colors.grey[800].withOpacity(0.5),
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Obx(() => DotsIndicator(
                      controller: _controller,
                      itemCount: pages.length,
                      onPageSelected: (int index) {
                        controller.currentIndex.value = index;
                        _controller.animateToPage(
                          index,
                          duration: _kDuration,
                          curve: _kCurve,
                        );
                        setPage();
                      },
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void setPage() {
    currentPage.value = (pages[controller.currentIndex.value] as AppPage);
  }
}
