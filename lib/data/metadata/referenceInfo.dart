import 'package:videotor/data/metadata/index.dart';
import 'package:flutter/material.dart';
import 'package:videotor/data/repo/repository.dart';

class ReferenceInfo {
  final String referencingColumn;
  final DataType dataType;
  final String foreignColumn;
  final int Function(dynamic) getForeignId;
  final Repository referenceRepo;

  ReferenceInfo({
    @required this.referencingColumn,
    @required this.referenceRepo,
    this.getForeignId,
    this.dataType: DataType.int,
    this.foreignColumn: "id",
  });

  @override
  String toString() {
    final foreignTable =
        this.referenceRepo.entityInstance().tableInfo.tableName;
    return 'FOREIGN KEY($referencingColumn) REFERENCES $foreignTable($foreignColumn)';
  }

  String columnify() {
    final type = DataTypeRepr.of(dataType);
    return "$referencingColumn $type NOT NULL";
  }
}
