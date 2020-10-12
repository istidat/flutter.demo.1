import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:videotor/api/index.dart';
import 'package:videotor/api/response/index.dart';
import 'package:videotor/entities/index.dart';
import 'package:videotor/services/index.dart';

abstract class Api {
  static HttpRequest mainRequest = Requests.main(defaultEnvironment);
  static Future<LoginResponse> login() async {
    if (mainRequest.isJsonRequest) {
      final u = await _parse(from: "assets/json/user.json");
      return LoginResponse(user: DataService.instanceOf(User).fromMap(u));
    }
    return LoginResponse()
      ..ofObject(await mainRequest.call(ApiMethod.httpGet, "user/signedin"));
  }

  static Future<Map<String, dynamic>> _parse({@required String from}) async {
    return rootBundle
        .loadString(from)
        .then((jsonStr) => jsonDecode(jsonStr) as Map<String, dynamic>);
  }
}
