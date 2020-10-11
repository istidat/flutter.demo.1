import 'dart:convert';
import 'package:flutter/material.dart';

typedef AttributerDelegate = void Function(dynamic);

abstract class GenericServer {
  @protected
  AttributerDelegate get attributer;
  Future<Map<String, dynamic>> toMap();

  Future<String> encodeMap() async {
    final map = await toMap();
    return  jsonEncode(map);
  }

  ofSource(String source) {
    attributer(jsonDecode(source));
  }

  ofObject(dynamic object) {
    attributer(object);
  }
}
