import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:renda_machine_clone/db/db_renda_machin.dart';
import 'package:renda_machine_clone/screens/backgroud_image_display.dart';
import 'home_screen.dart';
import 'stopwatch.dart';
import 'package:renda_machine_clone/screens/play_game_timeup.dart';
import 'mycustom_outline_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//プレイ画面
class PlayGameScreen extends StatefulWidget {
  final int rendaTimeValue;
  final int beforeSore;
  final String inputData;
  final DbRendaMachin dbRendaMachin;

  PlayGameScreen(
      {Key key, this.dbRendaMachin, this.rendaTimeValue, this.beforeSore, this.inputData})
      : super(key: key);

  @override
  PlayGameScreenState createState() => PlayGameScreenState();
}

class PlayGameScreenState extends State<PlayGameScreen> {
  final GlobalKey<FlutterStopWatchState> _key = GlobalKey(); //
  final GlobalKey<MyCustomOutlineButtonState> _key2 = GlobalKey();
  TextStyle textStyle = TextStyle(fontSize: 80.0.ssp, fontFamily: 'Bebas Neue');
  bool isPlayStartEnd = false;
  int _counter = 0;
  bool isPlayTimeUpFlag = false;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]); //ナビゲーションバーとステータスバーの非表示
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          BackgroundImageDisplay(), //背景画像表示
          SafeArea(
            child: Center(
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      //カウントアップ　又は　No　Limit 表示
                      widget.rendaTimeValue == 2 ? Text( //Endlessの場合
                        'NO LIMIT',
                        style: TextStyle(
                            fontSize: 50.0.ssp, fontFamily: 'Bebas Neue'),)
                          : FlutterStopWatch( //タイマーアップ　カウンタのインスタンス
                        key: _key,
                        dbRendaMachin: widget.dbRendaMachin,
                        rendaTimeValue: widget.rendaTimeValue,
                        inputdata: widget.inputData,
                        numberScore: widget.beforeSore,
                      ),
                      SizedBox(
                        width: 20.0.h,
                      ),
                      //TODO QUIT
                      _quitButtonDisplay(), //QUIT ボタン表示
                    ],
                  ),
                  //
                  (isPlayStartEnd) //連打ボタン押下、プレイスタート　true
                      ? _countRendDispaly() //連打カウント表示
                      : Text(
                    ' Press any button to Start',
                    style: TextStyle(
                        fontSize: 45.0.ssp),
                    //textAlign: TextAlign.start,
                  ),
                  //叩くボタン（４かける４）　表示
                  _rendaButtonLine(), //連打ボタン　１６個表示
                  _rendaButtonLine(),
                  _rendaButtonLine(),
                  _rendaButtonLine(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  //連打ボタン表示
  Widget _rendaButtonLine() {
    return Expanded(
      flex: 1,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(flex: 1, child: _rendaButton()),
          Expanded(flex: 1, child: _rendaButton()),
          Expanded(flex: 1, child: _rendaButton()),
          Expanded(flex: 1, child: _rendaButton()),
        ],
      ),
    );
  }
  //Quit ボタン押下時
  Future<void> _quitEndprocess() async {
    isPlayTimeUpFlag = false;
    //
    if (isPlayStartEnd == true && widget.rendaTimeValue != 2) {
      _key.currentState.stopResetStr(); //Quitボタン押された時、タイマーリセット
    }
    //
    isPlayStartEnd = false;
    if (widget.rendaTimeValue == 2) { //連打時間エンドレス時、データベース更新
      await widget.dbRendaMachin.scoreSetProcess(_counter, widget.inputData);

      Navigator.pop( //前の画面（ホーム）に戻る、連打カウントを返す
          context, _counter);
    } else {
      Navigator.pop(
          context, 0);
    }
    return;
  }
  //Quit ボタン表示
  Widget _quitButtonDisplay() {
    return MyCustomOutlineButton(
      key: _key2,
      text: 'QUIT',
      color: Colors.redAccent.withOpacity(0.3),
      onPressed: () => _quitEndprocess(),
      //width: double.infinity,
      redius1: 20.0.r,
      edge: 4.0.w,
      redius2: 15.0.r,
      fontsize: 55.0.ssp,
    );
  }
  //各連打ボタン表示＆押下時の処理
  Widget _rendaButton() {
    return MyCustomOutlineButton(
      key: new GlobalKey<MyCustomOutlineButtonState>(),
      text: '',
      color: Colors.redAccent.withOpacity(0.3),
      //width: double.infinity,
      redius1: 20.0.r,
      edge: 4.0.w,
      redius2: 15.0.r,
      fontsize: 60.0.ssp,
      onPressed: () {
        setState(() {
          if (widget.rendaTimeValue == 2) { //連打時間エンドレスの場合
            isPlayStartEnd = true;          //連打プレイスタート
            if (_counter == 0) _counter = _counter + widget.beforeSore;
            _counter++;
          } else { //エンドレス以外
            if (_counter == 0) {
              isPlayStartEnd = true;
              _key.currentState.startListenStr(); //タイムアップスタート
            }
            if (!_key.currentState.isTimeUpFlag) {
              _counter++;
              _key.currentState.scoreCount = _counter; //連打カウント　セット
            }
          }
        });
      },
    );
  }
  //連打回数表示
  Widget _countRendDispaly() {
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 15.0.h,
          ),
          Text(
            _counter.toString(),
            style: TextStyle(fontSize: 70.0.ssp),
          ),
          SizedBox(
            height: 15.0.h,
          ),
        ],
      ),
    );
  }
}
