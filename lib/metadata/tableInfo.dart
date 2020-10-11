import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:videotor/entities/index.dart';
import 'package:videotor/metadata/index.dart';
import 'package:videotor/helpers/index.dart';

class TableInfo<TEntity extends GenericEntity<TEntity>> {
  String get repr => translation.tr();
  final int version;
  final String translation;
  final String resource;
  final String tableName;
  final Iterable<FieldInfo<TEntity>> fieldInfos;
  final Iterable<ReferenceInfo> referenceInfos;
  final Iterable<One2OneReferenceInfo<TEntity>> one2OneReferences;
  final Iterable<CollectionInfo<TEntity>> collectionInfos;

  TableInfo({
    @required this.version,
    @required this.translation,
    @required this.resource,
    @required this.tableName,
    @required this.fieldInfos,
    this.referenceInfos,
    this.one2OneReferences,
    this.collectionInfos,
  }) : assert(fieldInfos.length > 0);

  @override
  String toString() {
    final fields = List.of([
      FieldInfo<TEntity>(
        repr: 'id',
        name: 'id',
        prop: Prop(
          getter: (e) => e.id.value,
          setter: (e, val) => e.id.value = val,
        ),
        dataType: DataType.int,
        displayOnForm: false,
        primaryKey: true,
      )
    ])
      ..addAll(fieldInfos);
    var cols =
        fields.map((col) => "$col").reduce((col1, col2) => "$col1, $col2");
    final refCols = referenceInfos
            ?.map((ref) => ", ${ref.columnify()}")
            ?.reduce((col1, col2) => col1 + col2) ??
        '';
    final refs = referenceInfos
            ?.map((ref) => ', $ref')
            ?.reduce((ref1, ref2) => ref1 + ref2) ??
        '';
    final o2oRefCols = one2OneReferences
            ?.map((ref) => ", ${ref.columnify()}")
            ?.reduce((col1, col2) => col1 + col2) ??
        '';
    final o2oRefs = one2OneReferences.whereElse(
      (ref) => ref.child == true,
      exists: (list) =>
          list.map((ref) => ', $ref').reduce((ref1, ref2) => ref1 + ref2),
      noElement: "",
    );
    final parameters =
        "${cols.trim()}${refCols.trim()}${o2oRefCols.trim()}${refs.trim()}${o2oRefs.trim()}"
            .stripTrailing(',');
    return 'CREATE TABLE $tableName($parameters);';
  }
}
