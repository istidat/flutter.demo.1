import 'package:videotor/api/index.dart';
import 'package:videotor/data/entities/index.dart';
import 'package:videotor/services/index.dart';

class Fetcher<T extends GenericEntity<T>> {
  final T Function() _tGenerator;
  Fetcher(this._tGenerator);

  Future<List<T>> fetchMany() async {
    final repo = DataService.repositoryOf<T>();
    final itemCount = await repo.count();
    if (itemCount > 0) {
      return await repo.all();
    }
    final response =
        await Api.mainRequest.single("${_tGenerator().tableInfo.resource}/");
    final listOfT = List<T>();
    for (var map in response['all']) {
      final item = _tGenerator().fromMap(map, omitId: true);
      await repo.insert(item);
      listOfT.add(item);
    }
    return listOfT;
  }

  Future<T> fetchOne(int id) async {
    final one =
        await Api.mainRequest.single("${_tGenerator().tableInfo.resource}/$id");
    return _tGenerator().fromMap(one, omitId: true);
  }
}
