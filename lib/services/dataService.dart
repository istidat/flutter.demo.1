import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:videotor/entities/index.dart';
import 'package:videotor/metadata/index.dart';
import 'package:videotor/repo/index.dart';

typedef GeneratorDelegate = GenericEntity Function();

class DataService {
  static final List<GeneratorDelegate> _generators = <GeneratorDelegate>[
    () => AppSettings(),
    () => User(),
  ];

  static final Map<Type, String> _tableNames = {
    AppSettings: "app_settings",
    User: "users",
  };
  static Database _database;
  static Database _prevDatabase;
  static const _version = 2;
  static Database get db => _prevDatabase ?? _database;

  Future<DataService> init() async {
    var databaseDirectory = await getDatabasesPath();
    final dbFile = File(join(databaseDirectory, "app.db"));
    if (_database == null) {
      _database = await openDatabase(
        dbFile.path,
        version: _version,
        onUpgrade: (db, prev, next) async {
          if (next > prev) {
            await _upgradeDatabase(db, next);
          }
        },
        onOpen: (db) async {
          if (!kReleaseMode) {
            //await recreateDB(db);
          }
        },
        onCreate: (Database db, int version) async {
          await recreateDB(db);
        },
      );
    }
    return this;
  }

  Future<void> _upgradeDatabase(Database db, int nextVersion) async {
    _prevDatabase = db;
    final repo = repositoryOf<User>();
    await recreateDB(db, newVersion: (ti) => ti.version == nextVersion);
    final prevDBUser = (await repo.all()).first;
    await recreateDB(db);
    await repo.insert(prevDBUser);
    _prevDatabase = null;
  }

  Future<void> pragmaForeignKeys({@required bool on, dbRef}) async {
    final word = on ? 'ON' : 'OFF';
    await (dbRef ?? db).execute('PRAGMA foreign_keys = $word;');
  }

  Future<void> recreateDB(
    Database db, {
    bool Function(TableInfo) newVersion,
  }) async {
    await pragmaForeignKeys(on: false, dbRef: db);
    for (var script in regenerateWhen(newVersion: newVersion)) {
      await db.execute(script);
    }
    await pragmaForeignKeys(on: true, dbRef: db);
  }

  Iterable<String> regenerateWhen({bool Function(TableInfo) newVersion}) {
    var scriptList = <String>[];
    for (var gen in _generators) {
      final e = gen();
      final regen = (bool drop) {
        if (drop) {
          scriptList.add("DROP TABLE IF EXISTS ${e.tableInfo.tableName};");
        }
        scriptList.add('${e.tableInfo}');
      };
      if (newVersion != null) {
        if (newVersion(e.tableInfo)) {
          regen(e.tableInfo.altered == false);
        }
      } else {
        regen(true);
      }
    }
    return scriptList;
  }

  static GenericEntity instanceOf(Type t) {
    return _generators.firstWhere((e) => e().runtimeType == t, orElse: null)();
  }

  static Repository<T> repositoryOf<T extends GenericEntity<T>>() {
    return Repository(() => instanceOf(T));
  }

  Fetcher<T> fetcherOf<T extends GenericEntity<T>>() {
    return Fetcher(() => instanceOf(T));
  }

  static String tableNameOf<T>() {
    final foundKey = _tableNames.keys.firstWhere(
      (key) => key == T,
      orElse: null,
    );
    assert(foundKey != null);
    return _tableNames[foundKey];
  }
}
