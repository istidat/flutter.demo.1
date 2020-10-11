import 'package:videotor/api/response/index.dart';
import 'package:http/http.dart' as http;

class AuthClient extends http.BaseClient {
  final TokenResponse tokenResponse;
  final http.Client _inner = http.Client();

  AuthClient(this.tokenResponse);

  Future<http.StreamedResponse> send(http.BaseRequest request) {
    if (tokenResponse.success == true) {
      request.headers['X-AUTH-TOKEN'] = tokenResponse.token;
      request.headers['Content-Type'] = 'application/json';
    } else {
      throw Exception(
        tokenResponse.exception ?? Exception("failed auth response"),
      );
    }
    return _inner.send(request);
  }
}
