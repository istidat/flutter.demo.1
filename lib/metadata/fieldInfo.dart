import 'package:videotor/metadata/index.dart';
import 'package:videotor/entities/index.dart';
import 'package:flutter/material.dart';

class FieldInfo<TEntity extends GenericEntity<TEntity>> {
  final String name;
  final String repr;
  final Prop<TEntity, dynamic> prop;
  final DataType dataType;
  final bool nullableOnForm;
  final bool displayOnForm;
  final bool primaryKey;
  final bool uniqueKey;
  final dynamic resetTo;

  FieldInfo({
    @required this.name,
    @required this.repr,
    @required this.prop,
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
