import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:videotor/entities/index.dart';
import 'package:videotor/metadata/index.dart';
import 'package:videotor/helpers/index.dart';

class EditField {
  static Widget of<TEntity extends GenericEntity<TEntity>>({
    @required FieldInfo<TEntity> fieldInfo,
    @required TEntity withEntity,
  }) {
    return _Field<TEntity>(fieldInfo, withEntity);
  }
}

class _Field<TEntity extends GenericEntity<TEntity>> extends GetView<TEntity> {
  final FieldInfo<TEntity> fieldInfo;
  final TEntity entity;
  _Field(this.fieldInfo, this.entity);

  final edited = false.obs;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: Text("edit_field").tr(
            namedArgs: {"field": "${fieldInfo.repr}"},
          ),
        ),
        body: Container(
          child: Card(
            child: Obx(() => Padding(
                  padding: EdgeInsets.all(30.0),
                  child: _buildField(),
                )),
            margin: EdgeInsets.all(20.0),
            elevation: 3.0,
            clipBehavior: Clip.antiAlias,
          ),
        ),
      ),
    );
  }

  Widget _buildField() {
    var inputType = TextInputType.text;
    dynamic Function(String) transform = (input) => input;
    switch (fieldInfo.dataType) {
      case DataType.int:
        inputType = TextInputType.numberWithOptions(
          decimal: false,
          signed: false,
        );
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
      final val = fieldInfo.prop.getter(this.entity);
      if (val is int && val == 0) {
        return "";
      }
      if (val is num && val == 0.0) {
        return "";
      }
      return val.toString();
    };
    if (text().length > 30) {
      inputType = TextInputType.multiline;
    }
    return TextFormField(
      initialValue: text(),
      minLines: 1,
      maxLines: text().length ~/ 29 + 1,
      keyboardType: inputType,
      textInputAction: TextInputAction.done,
      style: TextStyle(fontSize: 17),
      decoration: InputDecoration(labelText: fieldInfo.repr),
      onChanged: (value) {
        if (edited.value == false) {
          edited.value = true;
        }
        this.fieldInfo.prop.setter(this.entity, transform(value));
      },
      onEditingComplete: _back,
      validator: (value) {
        if (value.isEmpty) {
          return "error.value_empty".tr();
        } else if (fieldInfo.dataType == DataType.int) {
          return value.isInt ? null : "error.not_int".tr();
        } else {
          return null;
        }
      },
    );
  }

  Future<bool> _onBackPressed() async {
    _back();
    return Future.value(false);
  }

  void _back() {
    final _edited = edited.value;
    edited.value = false;
    Get.back(result: _edited);
  }
}
