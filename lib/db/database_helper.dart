import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final _databaseName = "renda_database.db";   // DB名
  static final _databaseVersion = 1;                  // 1で固定？
  static final table = 'renda_table';                 // テーブル名
  static final columnNickName = 'nickName';           //列１ 名前
  static final columnTenScore = 'scoreTen';           //列２ 10秒　スコア
  static final columnSixtyScore = 'scoreSixty';       //列３ 60秒
  static final columnEndLessScore = 'scoreEndLess';   //列４ エンドレス

  // DatabaseHelperクラスをシングルトンにするためのコンストラクタ
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  //DBにアクセスするためのメソッド
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    //初の場合はDBを作成する
    _database = await _initDatabase();
    return _database;
  }
  //データベースを開く。データベースがない場合は作る関数
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();  //ファイルを配置するディレクトリへのパスを返す
    String path = join(documentsDirectory.path, _databaseName);               // joinはセパレーターでつなぐ関数
    //pathのDBを開く。なければonCreateの処理がよばれる。onCreateでは_onCreateメソッドを呼び出している
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }
  //DBを作成するメソッド
  Future _onCreate(Database db, int version) async {
    //シングルクォート3つ重ねることで改行で文字列を作成できる。$変数名は、クラス内の変数のこと（文字列の中で使える）
    await db.execute('''
          CREATE TABLE $table (
            $columnNickName TEXT PRIMARY KEY,
            $columnTenScore  INTEGER NOT NULL,
            $columnSixtyScore INTEGER NOT NULL,
            $columnEndLessScore INTEGER NOT NULL
          )
          ''');
  }
  // Helper methods
  //挿入
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;//DBにアクセスする
    return await db.insert(table, row);//テーブルにマップ型のものを挿入。追加時のrowIDを返り値にする
  }
  // 全件取得
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;//DBにアクセスする
    return await db.query(table); //全件取得
  }
  // データ件数取得
  Future<int> queryRowCount() async {
    Database db = await instance.database;//DBにアクセスする
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }
  // dbに引数の名前があるか、あればその名前のデータ取得
  Future<List<Map<String,dynamic>>> queryRowNameWhat(String name) async {
    Database db = await instance.database;//DBにアクセスする
    String inputName = name;
    var response  = await db.query(table, where: '$columnNickName=?', whereArgs:[inputName]);
    return response;
  }
  //１０秒のランキングデータ取得（降順）
  Future<List<Map<String,dynamic>>> queryRowOrderByTen() async {
    Database db = await instance.database;//DBにアクセスする
     var response = await db.rawQuery(
        'SELECT $columnNickName,$columnTenScore FROM $table ORDER BY $columnTenScore DESC');
      return response;
  }
  //６０秒のランキングデータ取得（降順）
  Future<List<Map<String,dynamic>>> queryRowOrderBySixty() async {
    Database db = await instance.database;//DBにアクセスする
    var response  = await db.rawQuery(
        'SELECT $columnNickName,$columnSixtyScore FROM $table ORDER BY $columnSixtyScore DESC');
    return response;
  }
  //エンドレスのランキングデータ取得（降順）
  Future<List<Map<String,dynamic>>> queryRowOrderByEndLess() async {
    Database db = await instance.database;//DBにアクセスする
    var response = await db.rawQuery(
        'SELECT $columnNickName,$columnEndLessScore FROM $table ORDER BY $columnEndLessScore DESC');
    return response;
  }
  // 名前に相当するデータ更新
  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;//DBにアクセスする
    String Name = row[columnNickName];//引数のマップ型のcolumnNickNameを取得
    return await db.update(
        table, row, where: '$columnNickName = ?', whereArgs: [Name]);
  }
  // 名前に相当するデータ削除
  Future<int> delete(String Name) async {
    Database db = await instance.database;
    return await db.delete(
        table, where: '$columnNickName = ?', whereArgs: [Name]);
  }
}