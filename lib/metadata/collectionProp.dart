import 'package:videotor/repo/index.dart';
import 'package:videotor/entities/index.dart';
import 'package:flutter/material.dart';

class CollectionProp<TEntity extends GenericEntity<TEntity>> {
  final Iterable Function(TEntity) getter;
  final TEntity Function(TEntity, Iterable) setter;
  final Repository itemRepo;

  CollectionProp({
    @required this.getter,
    @required this.setter,
    this.itemRepo,
  });
}
