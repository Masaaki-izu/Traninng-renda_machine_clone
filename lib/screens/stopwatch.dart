import 'dart:async';
import 'package:flutter/material.dart';
import 'package:renda_machine_clone/screens/play_game_timeup.dart';
import 'package:renda_machine_clone/db/db_renda_machin.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:renda_machine_clone/cs.dart';

class FlutterStopWatch extends StatefulWidget {
  final int rendaSelectTimeValue;
  final String inputdata;
  final int numberScore;
  final DbRendaMachin dbRendaMachin;

  FlutterStopWatch(
      {Key key,
      this.dbRendaMachin,
      this.rendaSelectTimeValue,
      this.inputdata,
      this.numberScore})
      : super(key: key);

  @override
  FlutterStopWatchState createState() => FlutterStopWatchState();
}

class FlutterStopWatchState extends State<FlutterStopWatch> {
  final List<int> playTime = [10000, 60000, 0];
  bool flag = false;
  Stream<int> timerStream;
  StreamSubscription<int> timerSubscription;
  TextStyle textStyle = TextStyle(fontSize: 80.0.ssp, fontFamily: fontName2); //'Bebas Neue');
  int hundreds = 0;
  int seconds = 0;
  int scoreCount = 0;
  String secondsStr = '00';
  String hundredsStr = '00';
  bool isTimeUpFlag = false;

  Stream<int> stopWatchStream() {
    StreamController<int> streamController;
    Timer timer;
    Duration timerInterval = Duration(milliseconds: 1);
    int counter = 0;

    void stopTimer() {
      if (timer != null) {
        timer.cancel();
        timer = null;
        counter = 0;
        streamController.close();
      } else {
        flag = false;
      }
    }

    void tick(_) {
      counter++;
      if (counter == playTime[widget.rendaSelectTimeValue]) {
        flag = true;
      }
      streamController.add(counter);
      if (flag) {
        setState(() {
          stopTimer();
          isTimeUpFlag = true;
        });
      }
    }

    void startTimer() {
      timer = Timer.periodic(timerInterval, tick);
    }

    streamController = StreamController<int>(
      onListen: startTimer,
      onCancel: stopTimer,
      onResume: startTimer,
      onPause: stopTimer,
    );
    return streamController.stream;
  }

  @override
  void initState() {
    super.initState();
    if (widget.rendaSelectTimeValue == 0) {
      secondsStr = '10';
    } else {
      secondsStr = '60';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            secondsStr + '.' + hundredsStr,
            style: textStyle,
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }

  void startListenStr() {
    String sameChar = '', sameChar1 = '';
    timerStream = stopWatchStream();
    timerSubscription = timerStream.listen((int newTick) {
      //setState(() {
      hundreds = (newTick / 10).floor();
      seconds = (hundreds / 100).floor();
      hundredsStr = (hundreds % 100).toString().padLeft(2, '0');
      secondsStr = (seconds).toString().padLeft(2, '0');
      //});
      if (sameChar != hundredsStr || sameChar1 != secondsStr) {
        setState(() {
        });
      }
      sameChar = hundredsStr;
      sameChar1 = secondsStr;
      if (isTimeUpFlag) {
        _timeUpScreenTransition(secondsStr + '.' + hundredsStr);
      }
    });
  }

  void stopResetCounter() {
    timerSubscription.cancel();
    timerStream = null;
    setState(() {
      secondsStr = '00';
      hundredsStr = '00';
    });
  }

  Future<void> _timeUpScreenTransition(String timeCount) async {
    isTimeUpFlag = false;
    await widget.dbRendaMachin.scoreUpdateProcess(scoreCount, widget.inputdata);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PlayGameTimeUp(
                  dbRendaMachin: widget.dbRendaMachin,
                  rendaSelectTimeValue: widget.rendaSelectTimeValue,
                  rendaCount: scoreCount,
                  timeCount: timeCount,
                  inputData: widget.inputdata,
                  numberScore: widget.numberScore,
                ))).then((value) => {
          setState(() {}),
        });
  }
}
