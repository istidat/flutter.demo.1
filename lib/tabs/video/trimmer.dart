import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart' hide Trans;
import 'package:videotor/entities/index.dart';
import 'package:videotor/tabs/app_page.dart';

class TrimmerPage extends AppPage<VideoItem> {
  @override
  get translationKey => 'title.video_trim_page'.obs;

  @override
  get icon => Icon(Icons.settings).obs;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
