import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:renda_machine_clone/main.dart';
import 'package:renda_machine_clone/screens/backgroud_image_display.dart';
import 'play_game_screen.dart';
import 'play_game_timeup.dart';
import 'mycustom_outline_button.dart';
import 'package:renda_machine_clone/db/database_helper.dart';
import 'package:renda_machine_clone/db/db_renda_machin.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  final int score;
  final int returnRendaTimeValue;
  final DbRendaMachin returnDbRendaMachin;

  HomeScreen(
      {Key key, //識別するためのID
      this.returnDbRendaMachin, //データベースを利用するためのクラスのインスタンス
      this.returnRendaTimeValue, //連打時間選択（0: 10秒　1: 60秒　2: QUIT押されるまで
      this.score}) //連打カウント
      : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final GlobalKey<MyCustomOutlineButtonState> _key =
      GlobalKey(); // 共通使用のボタンクラスのGlobalKeyを取得
  final DbRendaMachin dbRendaMachin = DbRendaMachin(); //DB用の連打マシンクラスのインスタンス化
  final TextEditingController _textEditingController =
      TextEditingController(); //入力内容を管理するためのインスタンス化
  bool isNameInputData = false; //名前等の入力されたかのフラグ
  bool isSameUnNameFlag = false; //DBに同じ名前がない場合、true
  String inputDataString = ''; //入力した名前

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]); //ナビゲーションバーとステータスバーの非表示
    super.initState();
    //DBからデータ読み込み
    _rankingDataRead();
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setEnabledSystemUIOverlays(
        SystemUiOverlay.values); //ナビゲーションバーとステータスバーの表示するように戻す
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackgroundImageDisplay(), //背景画像表示
        Scaffold(
          backgroundColor: Colors.transparent, //透過化
          body: SingleChildScrollView(
            //端末縦サイズを超えたら、スクロール
            child: SafeArea(
              child: Center(
                child: Column(
                  children: <Widget>[
                    //スコア表示部分
                    _scoreDisplayPart(),
                    SizedBox(
                      height: 6.0.h, //画面の高さに適応(ScreenUtil）
                    ),
                    //ゲーム名表示部分
                    Text(
                      'Renda  ',
                      style: TextStyle(
                          fontSize: 53.0.ssp, //画面サイズによりサイズが拡大縮小
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Machine',
                      style: TextStyle(
                          fontSize: 53.0.ssp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 8.0.h,
                    ),
                    //タップ時、名前などの入力のダイアログ 表示
                    GestureDetector(
                      onTap: () {
                        //表示部分か、アイコンをタップすると、以下実行
                        _textEditingController.text = '';
                        _showInputDialog(); //入力ダイアログ表示
                        setState(() {
                          //
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            width: 5.0.w, //画面の幅に適応
                          ),
                          Container(
                            //alignment: Alignment.center,
                            width: 0.7.sw, //画面幅の0.7倍
                            //height: 0.1.sh,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: Colors.blue, width: 2.w), //画面幅に適応
                              borderRadius: BorderRadius.circular(
                                  8.0.r), //r,幅または高さの小さい方に応じて適応
                            ),
                            padding: EdgeInsets.all(10.w), //画面幅に適応
                            child: Center(
                              child: Text(
                                inputDataString,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 22.0.ssp,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Icon(Icons.touch_app_sharp,
                              color: Colors.white,
                              size: 24.0.ssp,
                              textDirection: TextDirection.rtl),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8.0.h,
                    ),
                    //連打時間選択ボタン
                    (isNameInputData) ? _rendaTimeSelect() : Container(),
                    SizedBox(
                      height: 13.0.h,
                    ),
                    //PLAYボタン(名前入力の判断後)
                    (isNameInputData)
                        ? _playButton(context)
                        : Container(
                            child: SizedBox(
                              height: 50.0.h,
                            ),
                          ),
                    SizedBox(
                      height: 40.0.ssp,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        //フォント等、その他表示
                        _gameDisplayExplanation(),
                        //ランキング表示
                        _rankingDisplay(), //pixRatio), //s10Data),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  //入力ダイアログ表示
  Future<void> _showInputDialog() async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false, //ボタン以外のクリックでは、ダイアログ を閉じれない
      builder: (_) => AlertDialog(
        contentPadding: EdgeInsets.all(8.0.r),
        content: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                autofocus: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xffffffff),
                  hintText: 'Enter NickName',
                  hintStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 24.0.ssp,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 54.0.w),
                ),
                keyboardType: TextInputType.text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24.0.ssp,
                ),
                maxLength: 10,
                //最大文字数　１０
                maxLengthEnforced: false,
                controller: _textEditingController,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10), //入力文字数　１０
                ],
              ),
            ),
          ],
        ),
        actions: <Widget>[
          FlatButton(
              child: Text(
                'CANCEL',
                style: TextStyle(fontSize: 20.0.ssp),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0.r),
                  side: BorderSide(color: Colors.white)),
              //const
              onPressed: () {
                //inputData = '';
                Navigator.pop(context, '');
                SystemChrome.restoreSystemUIOverlays(); //入力完了した後にUI設定を復元
              }),
          FlatButton(
              child: Text(
                'OK',
                style: TextStyle(fontSize: 20.0.ssp),
              ),
              //const
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0.r),
                  side: BorderSide(color: Colors.white)),
              onPressed: () {
                var name = _textEditingController.text;
                //最大文字数が１０文字を超えると、１０文字まで、切り出す
                if (name.length > 10) {
                  name = name.substring(0, 10);
                }
                Navigator.pop(context, name);
                SystemChrome.restoreSystemUIOverlays();
              })
        ],
      ),
    ).then((value) {
      if (value != '') {
        setState(() {
          _inputTextCheck(value);
        });
      }
    });
  }

  //入力した名前などチェック後セット
  void _inputTextCheck(String name) {
    if (name.isEmpty) {
      print("enter");
      return;
    }
    if (name.isNotEmpty) {
      inputDataString = name;
      setState(() {
        isNameInputData = true;
        _inputNameDBCheck(inputDataString);
      });
    }
  }

  //データベースから名前などの入力チェック
  Future<bool> _inputNameDBCheck(String name) async {
    final List<Map<String, dynamic>> _isWhatName =
        await dbRendaMachin.dbHelper.queryRowNameWhat(name);
    // 名前がない場合
    if (_isWhatName.isEmpty) {
      dbRendaMachin.number10OfScore = 0; //全部スコア　０
      dbRendaMachin.number60OfScore = 0;
      dbRendaMachin.numberEndOfScore = 0;
      isSameUnNameFlag = true;
      setState(() {});
      return false;
    } else {
      // 名前がある場合、score のデータセット
      dbRendaMachin.number10OfScore = _isWhatName[0]['scoreTen'];
      dbRendaMachin.number60OfScore = _isWhatName[0]['scoreSixty'];
      dbRendaMachin.numberEndOfScore = _isWhatName[0]['scoreEndLess'];
      isSameUnNameFlag = false;
      setState(() {});
      return true;
    }
  }

  //スコア表示部分
  Widget _scoreDisplayPart() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0.r, right: 8.0.r, top: 8.0.r),
      child: Table(
        children: [
          TableRow(children: [
            //スコア時間タイトル
            Center(
              //child: FittedBox(
              //  fit: BoxFit.fill,
              child: Text(
                "10s",
                style: TextStyle(
                  fontSize: 20.0.ssp,
                ),
              ), //),
            ),
            Center(
              child: Text(
                "60s",
                style: TextStyle(fontSize: 20.0.ssp),
              ), //),
            ),
            Center(
              child: Text(
                "ENDLESS",
                style: TextStyle(fontSize: 20.0.ssp),
              ), //),
            ),
          ]),
          TableRow(children: [
            //各スコアの表示
            Center(
                child: Text(
              (isNameInputData)
                  ? dbRendaMachin.number10OfScore.toString()
                  : "----",
              style: TextStyle(
                fontSize: 25.0.ssp,
                color: Colors.white,
              ),
            )),
            Center(
                child: Text(
              (isNameInputData)
                  ? dbRendaMachin.number60OfScore.toString()
                  : "----",
              style: TextStyle(
                fontSize: 25.0.ssp,
                color: Colors.white,
              ),
            )),
            Center(
                child: Text(
              (isNameInputData)
                  ? dbRendaMachin.numberEndOfScore.toString()
                  : "----",
              style: TextStyle(
                fontSize: 25.0.ssp,
                color: Colors.white,
              ),
            )),
          ])
        ],
      ),
    );
  }

  //連打時間選択（選択された時間は、色を変える）
  Widget _rendaTimeSelect() {
    final List<Color> colorData = [Colors.blue, Colors.blue, Colors.blue];
    colorData[dbRendaMachin.rendaTimeValue] = Colors.red;
    return Container(
      child: FittedBox(
        child: ButtonBar(
          alignment: MainAxisAlignment.center,
          children: <Widget>[
            OutlineButton(
              borderSide: BorderSide(color: colorData[0], width: 3.0),
              disabledBorderColor: Colors.black,
              highlightedBorderColor: Colors.red,
              child: Text(
                '10s',
                style: TextStyle(fontSize: 38.0.ssp, color: Colors.white),
              ),
              onPressed: () {
                setState(() {
                  dbRendaMachin.rendaTimeValue = 0; //連打時間　１０s　選択
                });
              },
            ),
            OutlineButton(
              borderSide: BorderSide(color: colorData[1], width: 3.0),
              disabledBorderColor: Colors.black,
              highlightedBorderColor: Colors.red,
              child: Text(
                '60s',
                style: TextStyle(fontSize: 38.0.ssp, color: Colors.white),
              ),
              onPressed: () {
                setState(() {
                  dbRendaMachin.rendaTimeValue = 1; //連打時間　６０s　選択
                });
              },
            ),
            OutlineButton(
              borderSide: BorderSide(color: colorData[2], width: 3.0),
              disabledBorderColor: Colors.black,
              highlightedBorderColor: Colors.red,
              child: Text(
                'ENDLESS',
                style: TextStyle(fontSize: 38.0.ssp, color: Colors.white),
              ),
              onPressed: () {
                setState(() {
                  dbRendaMachin.rendaTimeValue = 2; //連打時間　エンドレス　選択
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  // プレイ開始ボタン表示
  Widget _playButton(BuildContext context) {
    return Container(
      child: MyCustomOutlineButton(
        key: _key,
        text: 'PLAY',
        //色の透過を設定
        color: Colors.redAccent.withOpacity(0.3),
        onPressed: () => _playGameScreen(context),
        width: 0.8.sw,
        redius1: 30.0.r,
        edge: 2.0.w,
        redius2: 10.0.r,
        fontsize: 45.0.ssp,
      ),
    );
  }

  //プレイ開始のため次画面
  _playGameScreen(BuildContext context) {
    var beforeScore;
    if (inputDataString.isEmpty) return; //名前の入力がない場合
    //DBに同じ名前がない場合
    if (isSameUnNameFlag) {
      dbRendaMachin.insert(
          //データベースに１データ追加
          nickName: inputDataString,
          timeCount: dbRendaMachin.rendaTimeValue,
          score: 0);
      isSameUnNameFlag = false;
    }
    //スコアを次の画面に渡すための設定
    switch (dbRendaMachin.rendaTimeValue) {
      case 0:
        beforeScore = dbRendaMachin.number10OfScore;
        break;
      case 1:
        beforeScore = dbRendaMachin.number60OfScore;
        break;
      case 2:
        beforeScore = dbRendaMachin.numberEndOfScore;
        break;
    }
    Navigator.push(
        //プレイ画面へ画面遷移
        context,
        MaterialPageRoute(
            builder: (context) => PlayGameScreen(
                  dbRendaMachin: dbRendaMachin,
                  rendaTimeValue: dbRendaMachin.rendaTimeValue,
                  beforeSore: beforeScore,
                  inputData: inputDataString,
                ))).then((value) => {
          setState(() {}),
        });
  }

  //連打ゲーム表示の説明など
  //TODO:　仮のフォント使用、できれば実際のフォントに近いもの変更？
  Widget _gameDisplayExplanation() {
    final double fontSize1 = 18.0;
    return Expanded(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            //mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'FONT',
                style: TextStyle(
                  fontSize: fontSize1.ssp,
                ),
              ),
              Text(
                'Bebas Neue', //'Isurus Labs',
                style: TextStyle(
                  fontSize: fontSize1.ssp,
                ),
              ),
              Text(
                'ONZE',
                style: TextStyle(
                  fontSize: fontSize1.ssp,
                ),
              ),
              Text(
                'ICON',
                style: TextStyle(
                  fontSize: fontSize1.ssp,
                ),
              ),
              Text(
                'Material',
                style: TextStyle(
                  fontSize: fontSize1.ssp,
                ),
              ),
              Text(
                'SPECIAL THANKS',
                style: TextStyle(
                  fontSize: fontSize1.ssp,
                ),
              ),
              Text(
                'Material,@clone.iz',
                style: TextStyle(
                  fontSize: fontSize1.ssp,
                ),
              ),
              Text(
                '(c) 2021 izumi',
                style: TextStyle(
                  fontSize: fontSize1.ssp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //ランキング表示
  //TODO:　できれば実際の形の枠に変更したい
  Widget _rankingDisplay() {
    final double fontSize0 = 20.0; //タイトル表示のフォントサイズ
    final double fontSize1 = 15.0; //内容のフォントサイズ（降順１０位以内）
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        width: 240.0.w,
        height: 240.0.h,
        padding: EdgeInsets.only(left: 3.0.w),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red, width: 2.0.r),
        ),
        child: FittedBox(
          alignment: Alignment.topLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                ' Leaderboard',
                style: TextStyle(
                  fontSize: fontSize0.ssp,
                ),
              ),
              SizedBox(
                height: 1.0.h,
              ),
              Text(
                '1.' + dbRendaMachin.scoreData[dbRendaMachin.rendaTimeValue][0],
                style: TextStyle(
                  fontSize: fontSize1.ssp,
                ),
              ),
              Text(
                '2.' + dbRendaMachin.scoreData[dbRendaMachin.rendaTimeValue][1],
                style: TextStyle(
                  fontSize: fontSize1.ssp,
                ),
              ),
              Text(
                '3.' + dbRendaMachin.scoreData[dbRendaMachin.rendaTimeValue][2],
                style: TextStyle(
                  fontSize: fontSize1.ssp,
                ),
              ),
              Text(
                '4.' + dbRendaMachin.scoreData[dbRendaMachin.rendaTimeValue][3],
                style: TextStyle(
                  fontSize: fontSize1.ssp,
                ),
              ),
              Text(
                '5.' + dbRendaMachin.scoreData[dbRendaMachin.rendaTimeValue][4],
                style: TextStyle(
                  fontSize: fontSize1.ssp,
                ),
              ),
              Text(
                '6.' + dbRendaMachin.scoreData[dbRendaMachin.rendaTimeValue][5],
                style: TextStyle(
                  fontSize: fontSize1.ssp,
                ),
              ),
              Text(
                '7.' + dbRendaMachin.scoreData[dbRendaMachin.rendaTimeValue][6],
                style: TextStyle(
                  fontSize: fontSize1.ssp,
                ),
              ),
              Text(
                '8.' + dbRendaMachin.scoreData[dbRendaMachin.rendaTimeValue][7],
                style: TextStyle(
                  fontSize: fontSize1.ssp,
                ),
              ),
              Text(
                '9.' + dbRendaMachin.scoreData[dbRendaMachin.rendaTimeValue][8],
                style: TextStyle(
                  fontSize: fontSize1.ssp,
                ),
              ),
              Text(
                '10.' +
                    dbRendaMachin.scoreData[dbRendaMachin.rendaTimeValue][9],
                style: TextStyle(
                  fontSize: fontSize1.ssp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //データベースからランキング表示のためデータ読み込み
  Future<void> _rankingDataRead() async {
    await dbRendaMachin.setData10s();
    await dbRendaMachin.setData60s();
    await dbRendaMachin.setDataEndLess();
    setState(() {});
  }

  //データベースのデータ出力（デバッグ用）
  Future<void> _dataDBDisplay() async {
    final List<Map<String, dynamic>> _allData =
        await dbRendaMachin.dbHelper.queryAllRows();
    print("-------------");
    print('$_allData');
    print("-------------");
  }

  //データベースから一つ名前データを削除（デバッグ用）
  Future<void> _data1Delete(String _name) async {
    await dbRendaMachin.dbHelper.delete(_name);
  }

  //データベースから全ての名前データを削除（デバッグ用）
  Future<void> _dataAllDelete() async {
    String _name = '';
    final List<Map<String, dynamic>> _allData =
        await dbRendaMachin.dbHelper.queryAllRows();
    for (int i = 0; i < _allData.length; i++) {
      _name = _allData[i]['nickName'];
      await dbRendaMachin.dbHelper.delete(_name);
    }
  }
}
