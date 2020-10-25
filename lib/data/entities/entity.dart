import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:videotor/data/metadata/index.dart';
import 'package:videotor/services/index.dart';

abstract class GenericEntity<TEntity extends GenericEntity<TEntity>>
    extends GetxController {
  RxInt id = 0.obs;

  TableInfo<TEntity> get tableInfo;

  GenericEntity owner;

  void reset() {
    for (var fi in tableInfo.fieldInfos.where((e) => e.resetTo != null)) {
      fi.prop.setter(this, fi.resetTo);
    }
  }

  FieldInfo<TEntity> fieldInfo({@required String withName}) =>
      tableInfo.fieldInfos.firstWhere((fi) => fi.name == withName);

  void copy({TEntity from, bool includeOne2OneRefs: true}) {
    final fiList = tableInfo.fieldInfos.where((e) => e.displayOnForm == true);
    for (var fi in fiList) {
      final val = fi.prop.getter(from);
      fi.prop.setter(this, val);
    }
    final o2ORefCount = (tableInfo.one2OneReferences ?? []).length;
    if (o2ORefCount > 0 && includeOne2OneRefs) {
      for (var tO2ORef in tableInfo.one2OneReferences) {
        final val = tO2ORef.prop.getter(from);
        tO2ORef.prop.setter(this, val);
      }
    }
  }

  TEntity fromMap(Map<String, dynamic> map,
      {GenericEntity withOwner, bool omitId = false}) {
    TEntity t = DataService.instanceOf(TEntity);
    t.owner = withOwner ?? owner;
    if (omitId == false) {
      t.id.value = map["id"];
    }
    tableInfo.fieldInfos.forEach((fi) {
      if (fi.prop.defaultValueGetter != null && map[fi.name] == null) {
        fi.prop.setter(t, fi.prop.defaultValueGetter(t));
      } else {
        fi.prop.setter(t, map[fi.name]);
      }
    });
    if (tableInfo.collectionInfos != null) {
      tableInfo.collectionInfos.where((e) => map[e.name] != null).forEach(
          (ci) => ci.collectionProp.setter(
              t,
              map[ci.name]
                  .map((itemMap) => ci.collectionProp.itemRepo
                      .entityInstance()
                      .fromMap(itemMap, withOwner: this, omitId: omitId))
                  .toList()));
    }
    return t;
  }

  Future<Map<String, dynamic>> toMap() async {
    var map = Map<String, dynamic>();
    for (var field in tableInfo.fieldInfos) {
      map[field.name] =
          (field.prop.defaultValueGetter ?? field.prop.getter)(this as TEntity);
      if (field.prop.defaultValueGetter != null) {
        field.prop.setter(this as TEntity, map[field.name]);
      }
    }
    for (var field in tableInfo.referenceInfos ?? []) {
      final getter = field.getForeignId ?? (e) => e.id.value;
      map[field.referencingColumn] = getter(this.owner);
    }
    for (One2OneReferenceInfo<TEntity> o2OInfo
        in tableInfo.one2OneReferences ?? []) {
      if (o2OInfo.child) {
        map[o2OInfo.referencingColumn] = o2OInfo.prop.getter(this).id.value;
      }
    }
    return map;
  }

  Future<void> one2OneModifier(
    Future<void> Function(dynamic refInfo, GenericEntity referenceEntity)
        modifier,
  ) async {
    final o2ORefs = this.tableInfo.one2OneReferences ?? [];
    for (var tO2ORef in o2ORefs.where((r) => !r.child)) {
      final referenceInstance = tO2ORef.referenceRepository.entityInstance();
      final references = referenceInstance.tableInfo.one2OneReferences;
      if (references == null || references.length == 0) continue;

      final dynamic referenceO2O = references.firstWhere(
        (r) => r.foreignTable == this.tableInfo.tableName,
        orElse: null,
      );
      final whereString = "${referenceO2O.referencingColumn}=?";
      GenericEntity referenceEntity = await tO2ORef.referenceRepository.first(
        whereString: whereString,
        args: [this.id.value],
      );
      referenceEntity = referenceEntity ?? referenceInstance;
      referenceO2O.prop.setter(referenceEntity, this);
      await modifier(tO2ORef, referenceEntity);
    }
  }
}
