import 'package:renda_machine_clone/db/database_helper.dart';

//DB用の連打マシーンクラス
class DbRendaMachin {

  //DataBaseHelperをインスタンス化
  final dbHelper = DatabaseHelper.instance;
  //ランキング空データ
  List<List<String>> scoreData = [
    [
      ' ',
      ' ',
      ' ',
      ' ',
      ' ',
      ' ',
      ' ',
      ' ',
      ' ',
      ' ',
    ],
    [
      ' ',
      ' ',
      ' ',
      ' ',
      ' ',
      ' ',
      ' ',
      ' ',
      ' ',
      ' ',
    ],
    [
      ' ',
      ' ',
      ' ',
      ' ',
      ' ',
      ' ',
      ' ',
      ' ',
      ' ',
      ' ',
    ],
  ];

  int number10OfScore = 0;  //１０秒　スコア
  int number60OfScore = 0;  //６０秒 スコア
  int numberEndOfScore = 0; //エンドレス　スコア
  int rendaTimeValue = 0;   //連打時間選択（ ０：１０秒、１：６０秒、２：エンドレス）

  DbRendaMachin();

  //新データ追加(スコア　最初０)
  void insert({String nickName, int timeCount, int score}) async {
    List<int> indexData = [0, 0, 0];
    indexData[timeCount] = score;
    Map<String, dynamic> row = {
      DatabaseHelper.columnNickName: nickName,  //名前
      DatabaseHelper.columnTenScore: indexData[0],  //10秒　スコア
      DatabaseHelper.columnSixtyScore: indexData[1],//60秒 スコア
      DatabaseHelper.columnEndLessScore: indexData[2],//エンドレス　スコア
    };
    final name = await dbHelper.insert(row);
  }
  //全てのデータの内容を出力 [デバッグ用]
  void query() async {
    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');
    allRows.forEach((row) => print(row));
  }

  //すでにある１データを更新
  void update({String nickName, int timeCount, int score}) async {
    List<bool> inData = [false, false, false];
    inData[timeCount] = true;
    Map<String, dynamic> row = {
      DatabaseHelper.columnNickName: nickName,
      if (inData[0]) DatabaseHelper.columnTenScore: score,
      if (inData[1]) DatabaseHelper.columnSixtyScore: score,
      if (inData[2]) DatabaseHelper.columnEndLessScore: score,
    };
    final name = await dbHelper.update(row);
  }

  //1データを削除(現状、使用していない）
  void delete({String name}) async {
    // Assuming that the number of rows is the id for the last row.
    //final id = await dbHelper.queryRowCount();
    final rowsDeleted = await dbHelper.delete(name);
    print('deleted $rowsDeleted row(s): row $name');
  }

  //10秒のランキングデータ読み込み後セット
  Future<void> setData10s() async {
    var count = 0;
    var name = "";
    var score = 0;
    List<Map<String, dynamic>> _listTen = await dbHelper.queryRowOrderByTen();

    _listTen.forEach((row) {
      name = row['nickName'];
      score = row['scoreTen'];
      if (count < 10 && score > 0) this.scoreData[0][count] = ('$name:$score');
      count++;
    });
  }
  //60秒のランキングデータ読み込み後セット
  Future<void> setData60s() async {
    var count = 0;
    var name = "";
    var score = 0;
    List<Map<String, dynamic>> _listTen = await dbHelper.queryRowOrderBySixty();

    _listTen.forEach((row) {
      name = row['nickName'];
      score = row['scoreSixty'];
      if (count < 10 && score > 0) this.scoreData[1][count] = ('$name:$score');
      count++;
    });
  }
  //エンドレスのランキングデータ読み込み後セット
  Future<void> setDataEndLess() async {
    var count = 0;
    var name = "";
    var score = 0;
    List<Map<String, dynamic>> _listTen =
    await dbHelper.queryRowOrderByEndLess();

    _listTen.forEach((row) {
      name = row['nickName'];
      score = row['scoreEndLess'];
      if (count < 10 && score > 0) this.scoreData[2][count] = ('$name:$score');
      count++;
    });
  }
  // 各連打時間選択時、スコアの更新
  Future<void> scoreSetProcess(int gameScore,String inputData) async {
    //var inputText = _textEditingController.text;
    //print('$inputText');
    if (gameScore == 0)
      return;
    else {
      switch (this.rendaTimeValue) {
        case 0:                                  //10秒の場合（後、６０秒、エンドレス）
          if (gameScore > this.number10OfScore) {//前のスコアより大きい場合
            this.number10OfScore = gameScore;   //新スコアセット
            update(                             //DB データ更新
                nickName: inputData,
                timeCount: this.rendaTimeValue,
                score: this.number10OfScore);
            await setData10s();                 //ランキング更新
          }
          break;
        case 1:
          if (gameScore > this.number60OfScore) {
            this.number60OfScore = gameScore;
            update(
                nickName: inputData,
                timeCount: this.rendaTimeValue,
                score: this.number60OfScore);
            await setData60s();
          }
          break;
        case 2:
          if (gameScore > this.numberEndOfScore) {
            this.numberEndOfScore = gameScore;
            //更新
            update(
                nickName: inputData,
                timeCount: this.rendaTimeValue,
                score: this.numberEndOfScore);
            await setDataEndLess();
          }
          break;
      }
    }
  }
}
