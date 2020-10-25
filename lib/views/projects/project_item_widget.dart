import 'package:flutter/material.dart';
import 'package:videotor/data/entities/index.dart';
import 'package:videotor/helpers/index.dart';
import 'package:easy_localization/easy_localization.dart';

class ProjectItemWidget extends StatelessWidget {
  final VideoProject videoProject;

  ProjectItemWidget(this.videoProject);

  @override
  Widget build(BuildContext context) {
    var outlineTextStyle = TextStyle(
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
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          side: BorderSide(
            color: Colors.white,
            width: 3.0,
          ),
        ),
        child: Container(
          height: 91,
          child: Stack(
            children: [
              videoProject.thumbnail,
              Positioned(
                top: 12,
                right: 14,
                child: Text(
                  DateFormat(
                    'd MMMM yyyy',
                    EasyLocalization.of(context).locale.toString(),
                  ).format(videoProject.buildDate.value.toDateTime()),
                  style: outlineTextStyle,
                ),
              ),
              Center(
                child: Text(
                  videoProject.title.value.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: outlineTextStyle.copyWith(color: Colors.redAccent),
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
                      onPressed: videoProject.openProject,
                      child: Text(
                        "label.open_project".tr().toUpperCase(),
                        style: outlineTextStyle,
                      ),
                    ),
                    FlatButton(
                      onPressed: () {},
                      child: Text(
                        "label.export_project".tr().toUpperCase(),
                        style: outlineTextStyle,
                      ),
                    ),
                    FlatButton(
                      onPressed: videoProject.removeProject,
                      child: Text(
                        "label.delete_project".tr().toUpperCase(),
                        style: outlineTextStyle,
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
