import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final _databaseName = "renda_database.db";
  static final _databaseVersion = 1;
  static final table = 'renda_table';
  static final columnNickName = 'nickName';
  static final columnTenScore = 'scoreTen';
  static final columnSixtyScore = 'scoreSixty';
  static final columnEndLessScore = 'scoreEndLess';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnNickName TEXT PRIMARY KEY,
            $columnTenScore  INTEGER NOT NULL,
            $columnSixtyScore INTEGER NOT NULL,
            $columnEndLessScore INTEGER NOT NULL
          )
          ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  Future<List<Map<String,dynamic>>> queryRowNameData(String name) async {
    Database db = await instance.database;
    String inputName = name;
    var response  = await db.query(table, where: '$columnNickName=?', whereArgs:[inputName]);
    return response;
  }

  Future<List<Map<String,dynamic>>> queryRowDescendingOrderByTen() async {
    Database db = await instance.database;
     var response = await db.rawQuery(
        'SELECT $columnNickName,$columnTenScore FROM $table ORDER BY $columnTenScore DESC');
      return response;
  }

  Future<List<Map<String,dynamic>>> queryRowDescendingOrderBySixty() async {
    Database db = await instance.database;
    var response  = await db.rawQuery(
        'SELECT $columnNickName,$columnSixtyScore FROM $table ORDER BY $columnSixtyScore DESC');
    return response;
  }

  Future<List<Map<String,dynamic>>> queryRowDescendingOrderByEndless() async {
    Database db = await instance.database;
    var response = await db.rawQuery(
        'SELECT $columnNickName,$columnEndLessScore FROM $table ORDER BY $columnEndLessScore DESC');
    return response;
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    String Name = row[columnNickName];
    return await db.update(
        table, row, where: '$columnNickName = ?', whereArgs: [Name]);
  }

  Future<int> delete(String Name) async {
    Database db = await instance.database;
    return await db.delete(
        table, where: '$columnNickName = ?', whereArgs: [Name]);
  }
}