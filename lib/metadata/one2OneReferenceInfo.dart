import 'package:videotor/entities/index.dart';
import 'package:videotor/repo/index.dart';
import 'package:videotor/metadata/index.dart';
import 'package:flutter/material.dart';

class One2OneReferenceInfo<TEntity extends GenericEntity<TEntity>> {
  final String foreignTable;
  final String referencingColumn;
  final Repository referenceRepository;
  final Prop<TEntity, GenericEntity> prop;
  final int Function(dynamic) getForeignId;
  final DataType dataType;
  final String foreignColumn;
  final bool child;

  One2OneReferenceInfo({
    @required this.foreignTable,
    @required this.referencingColumn,
    @required this.referenceRepository,
    @required this.prop,
    this.getForeignId,
    this.dataType: DataType.int,
    this.foreignColumn: "id",
    this.child: false,
  });

  @override
  String toString() {
    if (this.child == true) {
      return 'FOREIGN KEY($referencingColumn) REFERENCES $foreignTable($foreignColumn)';
    } else {
      return "";
    }
  }

  String columnify() {
    if (this.child == true) {
      final type = DataTypeRepr.of(dataType);
      return "$referencingColumn $type NOT NULL";
    } else {
      return "";
    }
  }
}
