import 'dart:io';
import 'package:flutter/material.dart';
import 'package:videotor/entities/index.dart';
import 'package:easy_localization/easy_localization.dart';

class ProjectItemWidget extends StatelessWidget {
  final VideoProject videoProject;

  ProjectItemWidget(this.videoProject);

  @override
  Widget build(BuildContext context) {
    var flatButtonStyle = TextStyle(
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
    return Container(
      key: ValueKey(videoProject.id),
      child: Card(
        color: Colors.white38.withOpacity(0.3),
        margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          side: BorderSide(
            color: Colors.white,
            width: 3.0,
          ),
        ),
        child: Container(
          height: 91,
          child: Stack(
            children: [
              videoProject.thumbnail.value.isEmpty
                  ? Image.asset(
                      'assets/images/widgets/generic-thumbnail.png',
                      fit: BoxFit.fill,
                    )
                  : Image.file(
                      File(videoProject.thumbnail.value),
                      fit: BoxFit.fill,
                    ),
              Positioned(
                top: 12,
                right: 14,
                child: Text(
                  DateFormat(
                    'd MMMM yyyy',
                    EasyLocalization.of(context).locale.toString(),
                  ).format(DateTime.now()),
                  style: TextStyle(fontSize: 12, color: Colors.black),
                ),
              ),
              Center(
                child: Text(
                  videoProject.title.value.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: flatButtonStyle.copyWith(color: Colors.redAccent),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FlatButton(
                      onPressed: () {},
                      child: Text(
                        "label.open_project".tr().toUpperCase(),
                        style: flatButtonStyle,
                      ),
                    ),
                    FlatButton(
                      onPressed: () {},
                      child: Text(
                        "label.export_project".tr().toUpperCase(),
                        style: flatButtonStyle,
                      ),
                    ),
                    FlatButton(
                      onPressed: videoProject.removeProject,
                      child: Text(
                        "label.delete_project".tr().toUpperCase(),
                        style: flatButtonStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
