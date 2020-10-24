import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:videotor/entities/index.dart';
import 'package:videotor/controllers/index.dart';
import 'package:videotor/metadata/index.dart';
import 'package:videotor/helpers/index.dart';
import 'package:videotor/services/index.dart';

enum FormType {
  insert,
  edit,
}

class InsertForm {
  static Widget of<TEntity extends GenericEntity<TEntity>>(
    GlobalKey<FormState> formKey, {
    GenericEntity withOwner,
    void Function(TEntity) specializer,
  }) {
    return _Form<TEntity>(formKey, withOwner, specializer);
  }
}

class _Form<TEntity extends GenericEntity<TEntity>> extends StatelessWidget {
  final GenericEntity withOwner;
  final TEntity Function(TEntity) specializer;

  final TEntity _entity = DataService.instanceOf(TEntity);
  final GlobalKey<FormState> _formKey;
  final _edited = false.obs;

  _Form(this._formKey, [this.withOwner, this.specializer]);

  @override
  Widget build(BuildContext context) {
    List<Widget> formChildren = [
      Obx(() => Card(
            child: Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 30.0),
              child: _buildForm(context),
            ),
            margin: EdgeInsets.all(20.0),
            elevation: 3.0,
            clipBehavior: Clip.antiAlias,
          ))
    ];
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: Text("insert_item").tr(
            namedArgs: {"item": "${_entity.tableInfo.repr}"},
          ),
          actions: [
            FlatButton(
              child: Text(
                "label.save",
              ).tr(),
              onPressed: () async {
                final FormState form = _formKey.currentState;
                if (form.validate()) {
                  form.save();
                  if (specializer != null) {
                    specializer(_entity);
                  }
                  _entity.owner = withOwner;
                  this._edited.value = false;
                  final e =
                      await DataService.repositoryOf<TEntity>().insert(_entity);
                  Get.back(result: e);
                } else {
                  UIHelper.alert(
                    title: "alert.error_occurred".tr(),
                    message: "error.form_save".tr(),
                    multipleChoice: false,
                  );
                }
              },
            )
          ],
        ),
        body: ListView(
          scrollDirection: Axis.vertical,
          children: formChildren,
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: _buildFormInputs(
          context,
          _entity.tableInfo.fieldInfos.where((fi) => fi.displayOnForm).toList(),
        ),
      ),
    );
  }

  List<Widget> _buildFormInputs(
    BuildContext context,
    List<FieldInfo<TEntity>> fiList,
  ) {
    Tuple<FocusNode, Widget> currentTuple;
    return List<Widget>.generate(fiList.length, (index) {
      currentTuple = _buildField(
        context,
        fiList[index],
        previousNode: index > 0 ? currentTuple.it1 : null,
      );
      return currentTuple.it2;
    });
  }

  Tuple<FocusNode, Widget> _buildField(
      BuildContext context, FieldInfo<TEntity> fieldInfo,
      {FocusNode previousNode}) {
    var inputType = TextInputType.text;
    dynamic Function(String) transform = (input) => input;
    switch (fieldInfo.dataType) {
      case DataType.int:
        inputType = TextInputType.number;
        transform = (String input) => int.parse(input);
        break;
      case DataType.real:
        inputType = TextInputType.numberWithOptions(decimal: true);
        transform = (String input) => num.parse(input);
        break;
      default:
        break;
    }
    final text = () {
      final val = fieldInfo.prop.getter(this._entity);
      if (val is int && val == 0) {
        return "";
      }
      if (val is num && val == 0.0) {
        return "";
      }
      return val.toString();
    };
    final currentNode = previousNode ?? FocusNode();
    final nextFocus = FocusNode();
    return Tuple<FocusNode, Widget>(
      it1: nextFocus,
      it2: TextFormField(
        keyboardType: inputType,
        focusNode: currentNode,
        minLines: 1,
        maxLines: text().length ~/ 30 + 1,
        controller: TextEditingController(text: text()),
        onFieldSubmitted:
            _entity.tableInfo.fieldInfos.last.name == fieldInfo.name
                ? null
                : (term) {
                    currentNode.unfocus();
                    FocusScope.of(context).requestFocus(nextFocus);
                  },
        onSaved: (value) {
          fieldInfo.prop.setter(_entity, transform(value));
        },
        decoration: InputDecoration(labelText: fieldInfo.repr),
        enableSuggestions: true,
        textInputAction:
            _entity.tableInfo.fieldInfos.last.name == fieldInfo.name
                ? TextInputAction.done
                : TextInputAction.next,
        //maxLength: 32,
        style: TextStyle(fontSize: 20),
        validator: (value) {
          if (value.isEmpty) {
            return fieldInfo.nullableOnForm ? null : "error.value_empty".tr();
          } else if (fieldInfo.dataType == DataType.int) {
            return value.isInt ? null : "error.not_int".tr();
          } else {
            return null;
          }
        },
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    if (this._edited.value == true) {
      final response = await UIHelper.alert<String>(
        title: "alert.warning".tr(),
        message: "warning.changes_not_saved".tr(),
        approvalText: "alert.continue_saving_changes".tr(),
        cancellationText: "alert.exit_without_saving".tr(),
        onCancellation: () => Get.back(closeOverlays: true),
      );
      if (response == "ok") {
        return false;
      }
    }
    Get.find<HomeController>().adjoinFAB(cancel: true);
    return true;
  }
}
