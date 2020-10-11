import 'dart:convert';
import 'package:videotor/api/index.dart';
import 'package:videotor/api/response/index.dart';
import 'package:http/http.dart' as http;

class HttpRequest {
  HttpRequest({
    this.baseUrl,
    this.credentials,
    this.isJsonRequest: false,
    bool secured: false,
  }) {
    _host = secured ? 'https' : 'http';
  }
  final String baseUrl;
  final Credentials credentials;
  final isJsonRequest;
  TokenResponse _tokenResponse;
  String _host;

  Future _tokenize() async {
    final url = "$_host://$baseUrl/auth/tokenize";
    final client = http.Client();
    try {
      final response = await client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: await credentials.encodeMap(),
      );
      if (response.statusCode == 200) {
        _tokenResponse = TokenResponse()..ofSource(response.body);
      } else {
        try {
          _tokenResponse = TokenResponse()
            ..message = jsonDecode(response.body)["message"].toString();
        } catch (e) {
          _tokenResponse = TokenResponse()..exception = e;
        }
        _tokenResponse.retriedCount++;
      }
    } catch (e) {
      _tokenResponse = TokenResponse()..exception = e;
      _tokenResponse.retriedCount++;
    }
  }

  Future<dynamic> call(
    ApiMethod method,
    String path, {
    String body,
    bool doNotTokenize: false,
    bool bodyBytes: false,
    Map<String, String> params,
  }) async {
    if (doNotTokenize == false) {
      if (_tokenResponse == null) {
        await _tokenize();
      } else if (_tokenResponse.success == false) {
        if (_tokenResponse.retriedCount < 3) {
          await _tokenize();
        } else {
          throw _tokenResponse.exception;
        }
      }
    }

    http.Response response;
    var url = "$_host://$baseUrl/$path";
    if (params.length > 0) {
      url += "?";
      for (var e in params.entries) {
        final q = "${e.key}=${e.value}&";
        url += q;
      }
      url = url.substring(0, url.length - 1);
    }
    final client = doNotTokenize ? http.Client() : AuthClient(_tokenResponse);
    try {
      switch (method) {
        case ApiMethod.httpGet:
          response = await client.get(url);
          break;
        case ApiMethod.httpPost:
          response = await client.post(url, body: body);
          break;
        case ApiMethod.httpPut:
          response = await client.put(url, body: body);
          break;
        default:
          break;
      }
      return bodyBytes ? response.bodyBytes : jsonDecode(response.body);
    } finally {
      client.close();
    }
  }

  Future<Map<String, dynamic>> single(String path) async {
    return await this.call(ApiMethod.httpGet, path) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> post(String path, String body) async {
    return await this.call(ApiMethod.httpPost, path, body: body)
        as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> put(String path, String body) async {
    return await this.call(ApiMethod.httpPut, path, body: body)
        as Map<String, dynamic>;
  }

  Future<List<TItem>> getList<TItem>(String path) async {
    final iterable =
        (await this.call(ApiMethod.httpGet, path)) as List<dynamic>;
    return iterable.map((item) => item as TItem).toList();
  }
}
