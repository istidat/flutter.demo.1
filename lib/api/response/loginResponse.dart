import 'package:videotor/api/response/index.dart';
import 'package:videotor/data/entities/index.dart';
import 'package:videotor/services/index.dart';

class LoginResponse extends TokenResponse {
  User user;

  LoginResponse({
    this.user,
    String token,
    String message,
    bool success,
    Exception exception,
  }) : super(
          token: token,
          message: message,
          success: success,
          exception: exception,
        );

  @override
  Future<Map<String, dynamic>> toMap() async => {
        "user": await this.user.toMap(),
        "token": this.token,
        "message": this.message,
        "success": this.success,
      };

  @override
  get attributer => (object) {
        this.user =
            DataService.instanceOf(User).fromMap(object["user"], omitId: true);
        this.token = object["token"];
        this.message = object["message"];
        this.success = object["success"];
      };
}
