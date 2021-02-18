import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:renda_machine_clone/screens/play_game_timeup.dart';
import 'play_game_screen.dart';
import 'home_screen.dart';
import 'package:renda_machine_clone/db/db_renda_machin.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//ストップウォッチ（カウントアップ）10秒　又　60秒　stop
class FlutterStopWatch extends StatefulWidget {
  final int rendaTimeValue;
  final String inputdata;
  final int numberScore;
  final DbRendaMachin dbRendaMachin;

  FlutterStopWatch({Key key,
    this.dbRendaMachin,
    this.rendaTimeValue,
    this.inputdata,
    this.numberScore})
      : super(key: key);

  @override
  FlutterStopWatchState createState() => FlutterStopWatchState();
}

class FlutterStopWatchState extends State<FlutterStopWatch> {
  final List<int> playTime = [10000, 60000, 0];
  bool flag = false; //flag = true;
  Stream<int> timerStream; //ストリームのインスタンス
  StreamSubscription<int> timerSubscription; //ストリームのサブスクリプション
  TextStyle textStyle = TextStyle(
      fontSize: 80.0.ssp,
      fontFamily: "Bebas Neue");
  int hundreds = 0; // 1/100 秒
  int seconds = 0; // 秒
  int scoreCount = 0; //スコアカウント
  String secondsStr = '00'; //秒　文字列
  String hundredsStr = '00'; //1/100 秒　文字列
  bool isTimeUpFlag = false; //タイマーアップ　フラグ

  //ストップウォッチストリーム作成(毎秒後の経過時間を1/1000秒単位で提供するストリーム)
  Stream<int> stopWatchStream() {
    StreamController<int> streamController;
    Timer timer;
    Duration timerInterval = Duration(milliseconds: 1); // 1/1000 秒
    int counter = 0;

    //タイマー停止処理
    void stopTimer() {
      if (timer != null) {
        timer.cancel();
        timer = null;
        counter = 0;
        streamController.close();
      } else {
        flag = false; //flag = true;
      }
    }

    // 呼ばれるごとにカウンター　+1
    void tick(_) {
      counter++;
      // 10秒又は60秒後　カウンターストップ　flag = true
      if (counter == playTime[widget.rendaTimeValue]) {
        flag = true; //false;
      }
      streamController.add(counter); //ストリームがカウンター取得
      if (flag) {
        setState(() {
          stopTimer();
          isTimeUpFlag = true; //タイマーアップstopフラグ　true
        });
      }
    }

    // リッスンしている間、1/1000 秒ごと、tick関数が呼ばれる
    void startTimer() {
      timer = Timer.periodic(timerInterval, tick);
    }

    //StreamControllerのインスタンス化
    streamController = StreamController<int>(
      onListen: startTimer,
      onCancel: stopTimer,
      onResume: startTimer,
      onPause: stopTimer,
    );
    return streamController.stream;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            secondsStr + '.' + hundredsStr, //カウンタ表示
            style: textStyle, textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }

  // ボタン　押下時
  void startListenStr() {
    timerStream = stopWatchStream(); //ストップウォッチストリーム作成&タイマースタート

    timerSubscription = timerStream.listen((int newTick)  {//ストリームをリッスン //async
        setState(() {
          hundreds = (newTick / 10).floor(); //ミリ（1/1000) １０割って　１００分１
          seconds = (hundreds / 100).floor(); // 100で割って、１秒
          hundredsStr = (hundreds % 100).toString().padLeft(2, '0');
          secondsStr = (seconds).toString().padLeft(2, '0');
        });
        if (isTimeUpFlag) //タイムアップフラグによりカウンタストップ
        {
          _timeUpScreenTransition(secondsStr + '.' + hundredsStr); //タイムアップ後の処理へ
        }
      }
    );
  }

  // QUIT（RESET） ボタン　押下時
  void stopResetStr() {
    timerSubscription.cancel();
    timerStream = null;
    setState(() {
      secondsStr = '00';
      hundredsStr = '00';
    });
  }

  // タイマーアップ時、タイムアップ画面へ遷移
  Future<void> _timeUpScreenTransition(String timeCount) async {
    isTimeUpFlag = false;
    FlutterStopWatch dbKousin = FlutterStopWatch();
    await widget.dbRendaMachin
        .scoreSetProcess(scoreCount, widget.inputdata); //タイムアップ時、スコア等をデータベース更新

    //タイムアップ画面へ遷移
    Navigator.push(
        context, MaterialPageRoute(
        builder: (context) =>
            PlayGameTimeUp(
              dbRendaMachin: widget.dbRendaMachin,
              //データベース用のインスタンス
              rendaTimeValue: widget.rendaTimeValue,
              //連打時間選択の値
              rendaCount: scoreCount,
              //連打カウント
              timeCount: timeCount,
              // タイムアップ時間
              inputData: widget.inputdata,
              //名前などの入力データ
              numberScore: widget.numberScore, //前のスコア回数
              // isFlag: true,
            ))).then((value) =>
    {
      setState(() {}),
    });
  }
}
