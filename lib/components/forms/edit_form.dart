import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:videotor/components/forms/index.dart';
import 'package:videotor/data/entities/index.dart';
import 'package:videotor/helpers/index.dart';
import 'package:videotor/services/index.dart';

class EditForm {
  static Widget of<TEntity extends GenericEntity<TEntity>>({
    @required TEntity entity,
    GenericEntity withOwner,
    void Function(TEntity) specializer,
  }) {
    return _Form<TEntity>(withOwner, entity, specializer);
  }
}

class _Form<TEntity extends GenericEntity<TEntity>> extends StatelessWidget {
  final TEntity entity;
  final GenericEntity ownerEntity;
  final TEntity Function(TEntity) specializer;

  _Form(this.ownerEntity, this.entity, this.specializer);

  final edited = false.obs;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
          appBar: AppBar(
            title: Text("edit_item").tr(
              namedArgs: {"item": "${entity.tableInfo.repr}"},
            ),
            actions: [
              TextButton(
                child: Text(
                  "label.save",
                ).tr(),
                onPressed: () {
                  if (specializer != null) {
                    specializer(entity);
                  }
                  entity.owner = ownerEntity ?? entity.owner;
                  edited.value = false;
                  DataService.repositoryOf<TEntity>().update(entity);
                  Get.back(result: entity);
                },
              )
            ],
          ),
          body: ListView(
            scrollDirection: Axis.vertical,
            children: [
              Card(
                child: Padding(
                  padding: EdgeInsets.only(left: 20.0, bottom: 30.0),
                  child: _buildList(),
                ),
                margin: EdgeInsets.all(20.0),
                elevation: 3.0,
                clipBehavior: Clip.antiAlias,
              ),
            ],
          )),
    );
  }

  Widget _buildList() {
    var fiList =
        entity.tableInfo.fieldInfos.where((fi) => fi.displayOnForm).toList();
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(vertical: 10),
      itemCount: fiList.length,
      itemBuilder: (context, index) => ListTile(
        title: Text("${fiList[index].repr}"),
        subtitle: Obx(() => Text(
              "${fiList[index].prop.getter(entity)}",
              overflow: TextOverflow.ellipsis,
            )),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () async => edited.value = await Get.to<bool>(
          EditField.of(fieldInfo: fiList[index], withEntity: entity),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    if (edited.value == true) {
      UIHelper.snack(
        title: "alert.warning".tr(),
        message: "warning.changes_not_saved".tr(),
      );
      return false;
    }
    return true;
  }
}
