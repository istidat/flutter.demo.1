import 'package:videotor/api/index.dart';
import 'package:videotor/api/response/index.dart';

class Requests {
  static HttpRequest main(Environment env) {
    final demoCredentials =
        Credentials(identity: "25871077074", password: "8081");
    switch (env) {
      case Environment.localhost:
        return HttpRequest(
            baseUrl: "127.0.0.1:8000", credentials: demoCredentials);
      case Environment.prerelease:
        return HttpRequest(isJsonRequest: true);
      case Environment.production:
        return HttpRequest(
          baseUrl: "cemiapp.herokuapp.com",
          credentials: demoCredentials,
          secured: true,
        );
      default:
        return null;
    }
  }

  static HttpRequest esma = HttpRequest(baseUrl: "www.kaabalive.net");
}
