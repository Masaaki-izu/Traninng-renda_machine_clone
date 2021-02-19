import 'package:renda_machine_clone/db/database_helper.dart';

class DbRendaMachin {
  final dbHelper = DatabaseHelper.instance;
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

  int number10OfScore = 0;
  int number60OfScore = 0;
  int numberEndOfScore = 0;
  int rendaSelectTimeValue = 0;

  DbRendaMachin();

  void insert({String nickName, int timeCount, int score}) async {
    List<int> indexData = [0, 0, 0];
    indexData[timeCount] = score;
    Map<String, dynamic> row = {
      DatabaseHelper.columnNickName: nickName,
      DatabaseHelper.columnTenScore: indexData[0],
      DatabaseHelper.columnSixtyScore: indexData[1],
      DatabaseHelper.columnEndLessScore: indexData[2],
    };
    final name = await dbHelper.insert(row);
  }

  void query() async {
    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');
    allRows.forEach((row) => print(row));
  }

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

  void delete({String name}) async {
    final rowsDeleted = await dbHelper.delete(name);
    print('deleted $rowsDeleted row(s): row $name');
  }

  Future<void> setRankingData10s() async {
    var count = 0;
    var name = "";
    var score = 0;
    List<Map<String, dynamic>> _listTen =
        await dbHelper.queryRowDescendingOrderByTen();

    _listTen.forEach((row) {
      name = row['nickName'];
      score = row['scoreTen'];
      if (count < 10 && score > 0) this.scoreData[0][count] = ('$name:$score');
      count++;
    });
  }

  Future<void> setRankingData60s() async {
    var count = 0;
    var name = "";
    var score = 0;
    List<Map<String, dynamic>> _listSixty =
        await dbHelper.queryRowDescendingOrderBySixty();

    _listSixty.forEach((row) {
      name = row['nickName'];
      score = row['scoreSixty'];
      if (count < 10 && score > 0) this.scoreData[1][count] = ('$name:$score');
      count++;
    });
  }

  Future<void> setRankingDataEndless() async {
    var count = 0;
    var name = "";
    var score = 0;
    List<Map<String, dynamic>> _listEndless =
        await dbHelper.queryRowDescendingOrderByEndless();

    _listEndless.forEach((row) {
      name = row['nickName'];
      score = row['scoreEndLess'];
      if (count < 10 && score > 0) this.scoreData[2][count] = ('$name:$score');
      count++;
    });
  }

  Future<void> scoreUpdateProcess(int gameScore, String inputData) async {
    if (gameScore == 0)
      return;
    else {
      switch (this.rendaSelectTimeValue) {
        case 0:
          if (gameScore > this.number10OfScore) {
            this.number10OfScore = gameScore;
            update(
                nickName: inputData,
                timeCount: this.rendaSelectTimeValue,
                score: this.number10OfScore);
            await setRankingData10s();
          }
          break;
        case 1:
          if (gameScore > this.number60OfScore) {
            this.number60OfScore = gameScore;
            update(
                nickName: inputData,
                timeCount: this.rendaSelectTimeValue,
                score: this.number60OfScore);
            await setRankingData60s();
          }
          break;
        case 2:
          if (gameScore > this.numberEndOfScore) {
            this.numberEndOfScore = gameScore;
            //更新
            update(
                nickName: inputData,
                timeCount: this.rendaSelectTimeValue,
                score: this.numberEndOfScore);
            await setRankingDataEndless();
          }
          break;
      }
    }
  }
}
