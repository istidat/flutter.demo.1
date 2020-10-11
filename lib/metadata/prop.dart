import 'package:videotor/entities/index.dart';
import 'package:flutter/material.dart';

class Prop<TEntity extends GenericEntity<TEntity>, TProp> {
  final TProp Function(TEntity) getter;
  final void Function(TEntity, TProp) setter;
  final TProp Function(TEntity) defaultValueGetter;
  Prop({
    @required this.getter,
    @required this.setter,
    this.defaultValueGetter,
  });
}
