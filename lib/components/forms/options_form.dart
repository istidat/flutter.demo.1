import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';

abstract class OptionForm {
  Widget get title;
  Widget get subtitle;
  get item;
}

typedef _Form NextFormCallback(OptionForm withModel);

class OptionsForm {
  static _Form of(
      {@required String titleTranslation,
      List<OptionForm> options,
      NextFormCallback nextForm}) {
    return _Form(titleTranslation, options, nextForm);
  }
}

class _Form extends StatelessWidget {
  final String titleTranslation;
  final List<OptionForm> options;
  final NextFormCallback nextForm;
  _Form(
    this.titleTranslation,
    this.options,
    this.nextForm,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          this.titleTranslation,
        ).tr(),
        actions: [
          TextButton(
            child: Text(
              "alert.cancel",
            ).tr(),
            onPressed: () {
              Get.back();
            },
          )
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 10),
      children: options
          .map((option) => ListTile(
                leading:
                    this.nextForm == null ? Icon(Icons.arrow_back_ios) : null,
                trailing: this.nextForm != null
                    ? Icon(Icons.arrow_forward_ios)
                    : null,
                title: option.title,
                subtitle: option.subtitle,
                onTap: () async {
                  if (this.nextForm == null) {
                    Get.back(result: option);
                  } else {
                    final result = await Get.to(
                      this.nextForm(option),
                      fullscreenDialog: true,
                      preventDuplicates: false,
                    );
                    Get.back(result: result);
                  }
                },
              ))
          .toList(),
    );
  }
}
