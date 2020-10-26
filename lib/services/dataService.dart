import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:videotor/data/entities/index.dart';
import 'package:videotor/data/repo/index.dart';

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
  static Database _db;
  static Database _prevDB;
  static const _version = 2;
  static Database get db => _prevDB ?? _db;

  Future<DataService> init() async {
    var databaseDirectory = await getDatabasesPath();
    final dbFile = File(join(databaseDirectory, "app.db"));
    if (_db == null) {
      _db = await openDatabase(
        dbFile.path,
        version: _version,
        onUpgrade: (db, prev, next) async {
          await _upgrade(db);
        },
        onOpen: (db) async {
          if (!kReleaseMode) {
            // await regenerateDB(db);
          }
        },
        onCreate: (Database db, int version) async {
          await regenerateDB(db);
        },
      );
    }
    return this;
  }

  Future _upgrade(Database db) async {
    _prevDB = db;
    await regenerateDB(db, forUpgrade: true);
  }

  Future<void> pragmaForeignKeys({@required bool on}) async {
    final word = on ? 'ON' : 'OFF';
    await (db).execute('PRAGMA foreign_keys = $word;');
  }

  Future<void> regenerateDB(Database _db, {bool forUpgrade: false}) async {
    _prevDB = _db;
    await pragmaForeignKeys(on: false);
    for (var gen in _generators) {
      final e = gen();
      final recreate = ({bool altered: false}) async {
        await db.execute("DROP TABLE IF EXISTS ${e.tableInfo.tableName};");
        await db.execute('${e.tableInfo}');
        if (altered) {
          final liRes = await db.rawQuery('${e.tableInfo.alterStatements}');
          if (liRes.length == 0) {
            final String alterStatement = liRes.first['ALTER_STMT'];
            db.execute(alterStatement);
          }
        }
      };
      if (forUpgrade && e.tableInfo.version == _version) {
        await recreate();
      } else if (e.tableInfo.altered) {
        await recreate(altered: true);
      } else if (forUpgrade == false) {
        await recreate();
      }
    }
    await pragmaForeignKeys(on: true);
    _prevDB = null;
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
