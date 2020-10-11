import 'package:videotor/api/response/index.dart';

class TokenResponse extends GenericServer {
  String token;
  String message;
  bool success = false;
  Object exception;
  int retriedCount = 0;

  TokenResponse({
    this.token,
    this.message,
    this.success,
    this.exception,
  });

  @override
  Future<Map<String, dynamic>> toMap() async => {
        "token": this.token,
        "message": this.message,
        "success": this.success,
      };

  @override
  get attributer => (object) {
        this.token = object["token"];
        this.message = object["message"];
        this.success = object["success"];
      };
}
