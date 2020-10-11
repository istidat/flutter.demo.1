import 'package:videotor/api/response/index.dart';

class Credentials extends GenericServer {
  String identity;
  String password;

  Credentials({
    this.identity,
    this.password,
  });

  @override
  get attributer => (object) {
        this.identity = object["UserName"];
        this.password = object["Password"];
      };

  @override
  Future<Map<String, dynamic>> toMap() async => {
        "identity": this.identity,
        "password": this.password,
      };
}
