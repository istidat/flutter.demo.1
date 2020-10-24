import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:videotor/entities/index.dart';
import 'package:videotor/repo/index.dart';

typedef GeneratorDelegate = GenericEntity Function();

class DataService {
  static final List<GeneratorDelegate> _generators = <GeneratorDelegate>[
    () => AppSettings(),
    () => User(),
    () => VideoProject(),
    () => VideoItem(),
  ];

  static final Map<Type, String> _tableNames = {
    AppSettings: "app_settings",
    User: "users",
  };
  static Database _database;
  static Database _prevDatabase;
  static const _version = 4;
  static Database get db => _prevDatabase ?? _database;

  Future<DataService> init() async {
    var databaseDirectory = await getDatabasesPath();
    final dbFile = File(join(databaseDirectory, "app.db"));
    if (_database == null) {
      _database = await openDatabase(
        dbFile.path,
        version: _version,
        onUpgrade: (db, prev, next) async {
          await _upgrade(db);
        },
        onOpen: (db) async {
          if (!kReleaseMode) {
            // await recreateDB(db);
          }
        },
        onCreate: (Database db, int version) async {
          await recreateDB(db);
        },
      );
    }
    return this;
  }

  Future _upgrade(Database db) async {
    _prevDatabase = db;
    await recreateDB(db, forUpgrade: true);
    _prevDatabase = null;
  }

  Future<void> pragmaForeignKeys({@required bool on, dbRef}) async {
    final word = on ? 'ON' : 'OFF';
    await (dbRef ?? db).execute('PRAGMA foreign_keys = $word;');
  }

  Future<void> recreateDB(Database db, {bool forUpgrade: false}) async {
    await pragmaForeignKeys(on: false, dbRef: db);
    for (var script in regenerateScripts(forUpgrade: forUpgrade)) {
      await db.rawQuery(script);
    }
    await pragmaForeignKeys(on: true, dbRef: db);
  }

  Iterable<String> regenerateScripts({bool forUpgrade: false}) {
    var scriptList = <String>[];
    for (var gen in _generators) {
      final e = gen();
      final recreate = () {
        scriptList.add("DROP TABLE IF EXISTS ${e.tableInfo.tableName};");
        scriptList.add('${e.tableInfo}');
      };
      if (forUpgrade && e.tableInfo.version == _version) {
        recreate();
      } else if (e.tableInfo.altered) {
        recreate();
        scriptList.add('${e.tableInfo.alterStatements}');
      } else if (forUpgrade == false) {
        recreate();
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
