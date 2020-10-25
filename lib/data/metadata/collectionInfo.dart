import 'package:videotor/data/metadata/index.dart';
import 'package:videotor/data/entities/index.dart';
import 'package:flutter/material.dart';

class CollectionInfo<TEntity extends GenericEntity<TEntity>> {
  final String name;
  final CollectionProp<TEntity> collectionProp;
  CollectionInfo({
    @required this.name,
    @required this.collectionProp,
  });
}
