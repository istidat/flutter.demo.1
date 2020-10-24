import 'package:get/get.dart' hide Trans;
import 'package:videotor/entities/index.dart';
import 'package:videotor/metadata/index.dart';
import 'package:videotor/services/index.dart';

class Repository<T extends GenericEntity<T>> {
  final T Function() entityInstance;

  Repository(this.entityInstance);

  Future<List<T>> all({
    String whereString,
    List<dynamic> args,
  }) async {
    var t = entityInstance();
    var map = await DataService.db.transaction(
      (txn) async => await txn.query(
        t.tableInfo.tableName,
        where: whereString,
        whereArgs: args,
      ),
    );
    List<T> list = [];
    if (map.isNotEmpty) {
      for (var itemMap in map) {
        t = t.fromMap(itemMap);
        final tId = t.id.value;
        for (var collInfo in t.tableInfo.collectionInfos ?? []) {
          List<dynamic> items;
          final TableInfo itemTableInfo =
              collInfo.collectionProp.itemRepo.entityInstance().tableInfo;
          final ReferenceInfo itemReferenceInfo =
              itemTableInfo.referenceInfos.firstWhere(
            (refInfo) =>
                refInfo.referenceRepo.entityInstance().tableInfo.tableName ==
                t.tableInfo.tableName,
            orElse: () => null,
          );
          final whereString = "${itemReferenceInfo.referencingColumn}=?";
          items = await collInfo.collectionProp.itemRepo.all(
            whereString: whereString,
            args: [tId],
          );
          items.forEach((it) => it.owner = t);
          collInfo.collectionProp.setter(t, items);
        }
        await t.one2OneModifier((refInfo, referenceEntity) async =>
            refInfo.prop.setter(t, referenceEntity));
        list.add(t);
      }
    }
    return list;
  }

  Future<T> first({
    String whereString,
    List<dynamic> args,
  }) async {
    final list = await all(whereString: whereString, args: args);
    if (list.length > 0) {
      return list.first;
    } else {
      return null;
    }
  }

  Future<int> deleteAll({TableInfo ti}) async {
    int total = 0;
    final _ti = ti ?? (entityInstance().tableInfo);
    var childCount = (_ti.collectionInfos ?? []).length;
    if (childCount > 0) {
      for (var ci in _ti.collectionInfos) {
        final childTi = ci.collectionProp.itemRepo.entityInstance().tableInfo;
        total += await deleteAll(ti: childTi);
      }
    }
    await Get.find<DataService>().pragmaForeignKeys(on: false);
    childCount = (_ti.one2OneReferences ?? []).length;
    if (childCount > 0) {
      for (var tO2ORef in _ti.one2OneReferences) {
        if (tO2ORef.child == false) {
          final childTi =
              tO2ORef.referenceRepository.entityInstance().tableInfo;
          total += await deleteAll(ti: childTi);
        }
      }
    }
    total += await DataService.db.transaction(
      (txn) async {
        int c = await txn.rawDelete("DELETE from ${_ti.tableName}");
        return c;
      },
    );
    await Get.find<DataService>().pragmaForeignKeys(on: true);
    return total;
  }

  Future<T> single(int id) async {
    var map = await DataService.db.transaction(
      (txn) async => await txn.query(
        entityInstance().tableInfo.tableName,
        where: 'id = ?',
        whereArgs: [id],
      ),
    );
    return map.isNotEmpty ? (entityInstance().fromMap(map.first)) : null;
  }

  Future<int> count() async {
    final map = await DataService.db.transaction(
      (txn) async => await txn.rawQuery(
          "SELECT COUNT(*) AS C FROM ${entityInstance().tableInfo.tableName}"),
    );
    return map.first["C"].toInt();
  }

  Future<T> insert(T entity) async {
    entity.id.value = await DataService.db.transaction((txn) async =>
        await txn.insert(entity.tableInfo.tableName, await entity.toMap()));
        
    await entity.one2OneModifier((refInfo, referenceEntity) async {
      final e = (await refInfo.referenceRepository.insert(referenceEntity));
      refInfo.prop.setter(entity, e);
    });

    for (CollectionInfo<T> collInfo in entity.tableInfo.collectionInfos ?? []) {
      var items = collInfo.collectionProp.getter(entity);
      for (var item in items) {
        await collInfo.collectionProp.itemRepo.insert(item..owner = entity);
      }
    }
    return entity;
  }

  Future<int> update(T entity, {bool digin: false}) async {
    var c = await DataService.db.transaction(
      (txn) async => await txn.update(
        entity.tableInfo.tableName,
        await entity.toMap(),
        where: "id = ?",
        whereArgs: [entity.id.value],
      ),
    );
    if (digin) {
      for (CollectionInfo<T> collInfo
          in entity.tableInfo.collectionInfos ?? []) {
        var items = collInfo.collectionProp.getter(entity);
        for (var item in items) {
          item.owner = entity;
          c +=
              await collInfo.collectionProp.itemRepo.update(item, digin: digin);
        }
      }
    }

    return c;
  }

  Future<int> updateColumns(T entity, List<String> columns) async {
    final entries = columns.map(
      (colName) => MapEntry(
        colName,
        entity.fieldInfo(withName: colName).prop.getter(entity),
      ),
    );
    return await DataService.db.transaction(
      (txn) async => await txn.update(
        entity.tableInfo.tableName,
        Map.fromEntries(entries),
        where: "id = ?",
        whereArgs: [entity.id.value],
      ),
    );
  }

  Future<int> delete(T entity) async {
    var deletedCount = 0;
    for (var collInfo in entity.tableInfo.collectionInfos ?? []) {
      var items = collInfo.collectionProp.getter(entity);
      for (var item in items) {
        deletedCount += await collInfo.collectionProp.itemRepo.delete(item);
      }
    }

    deletedCount += await DataService.db.transaction(
      (txn) async => await txn.delete(
        entity.tableInfo.tableName,
        where: "id = ?",
        whereArgs: [entity.id.value],
      ),
    );

    return deletedCount;
  }

  Future<T> upsert(T entity) async {
    final existing =
        await DataService.repositoryOf<T>().single(entity.id.value);
    if (existing == null) {
      return await this.insert(entity);
    } else {
      return existing;
    }
  }
}
