import 'package:videotor/api/response/index.dart';

class EsmaResponse extends GenericServer {
  String path;
  EsmaResponse({this.path});

  @override
  Future<Map<String, dynamic>> toMap() async => {
        "path": this.path,
      };

  @override
  get attributer => (object) {
        this.path = object;
      };
}
