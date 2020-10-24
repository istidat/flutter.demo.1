import 'package:videotor/metadata/index.dart';
import 'package:videotor/entities/index.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class FieldInfo<TEntity extends GenericEntity<TEntity>> {
  final String name;
  String get repr => translation.tr();
  final String translation;
  final Prop<TEntity, dynamic> prop;
  final bool newVersion;
  final DataType dataType;
  final bool nullableOnForm;
  final bool displayOnForm;
  final bool primaryKey;
  final bool uniqueKey;
  final dynamic resetTo;

  FieldInfo({
    @required this.name,
    @required this.translation,
    @required this.prop,
    this.newVersion: false,
    this.nullableOnForm: false,
    this.dataType: DataType.text,
    this.displayOnForm: true,
    this.primaryKey: false,
    this.uniqueKey: false,
    this.resetTo,
  });

  @override
  String toString() {
    final unique = uniqueKey ? " UNIQUE" : "";
    final type = DataTypeRepr.of(dataType);
    return primaryKey
        ? "$name $type PRIMARY KEY NOT NULL"
        : "$name $type$unique";
  }
}
