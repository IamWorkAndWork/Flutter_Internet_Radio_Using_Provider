import 'package:flutter_internet_radio_using_provider/models/db_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

abstract class DB {
  static Database _db;

  static int get _version => 1;

  static Future<void> init() async {
    if (_db != null) {
      return;
    }

    try {
      var databasPath = await getDatabasesPath();
      String _path = path.join(databasPath, "RadioApp.db");
      _db = await openDatabase(_path, version: _version, onCreate: onCreate);
    } catch (e) {
      print(e);
    }
  }

  static Future<void> onCreate(Database db, int version) async {
    await db.execute(
        'create table radios (id integer primary key not null, radioName string, radioURL string, radioDesc string, radioWebsite string, radioPic string)');

    await db.execute(
        'create table radios_bookmarks (id integer primary key not null, isFavourite integer)');
  }

  static Future<List<Map<String, dynamic>>> query(String table) async {
    return _db.query(table);
  }

  static Future<List<Map<String, dynamic>>> rawQuery(String sql) async {
    return _db.rawQuery(sql);
  }

  static Future<int> insert(String table, DBBaseBoldel model) async {
    try {
      await _db.insert(table, model.toMap());
      // print("insert success = ${model.toMap().toString()}");
    } catch (e) {
      print("insert error = ${e.toString()}");
    }
  }

  static rawInsert(String sql) async => await _db.rawInsert(sql);
}
