import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:renda_machine_clone/db/db_renda_machin.dart';
import 'package:renda_machine_clone/screens/backgroud_image_display.dart';
import 'stopwatch.dart';
import 'mycustom_outline_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:renda_machine_clone/cs.dart';

class PlayGameScreen extends StatefulWidget {
  final int rendaSelectTimeValue;
  final int beforeSore;
  final String inputData;
  final DbRendaMachin dbRendaMachin;

  PlayGameScreen(
      {Key key, this.dbRendaMachin, this.rendaSelectTimeValue, this.beforeSore, this.inputData})
      : super(key: key);

  @override
  PlayGameScreenState createState() => PlayGameScreenState();
}

class PlayGameScreenState extends State<PlayGameScreen> {
  final GlobalKey<FlutterStopWatchState> _key = GlobalKey();
  final GlobalKey<MyCustomOutlineButtonState> _key2 = GlobalKey();
  TextStyle textStyle = TextStyle(fontSize: 80.0.ssp, fontFamily: fontName2);
  bool isPlayStart = false;
  int _counter = 0;
  bool isPlayTimeUpFlag = false;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
    );
    if (widget.rendaSelectTimeValue == 2 )  _counter = widget.beforeSore;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          BackgroundImageDisplay(),
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        widget.rendaSelectTimeValue == 2 ?
                         Text('NO LIMIT',
                          style: TextStyle(
                              fontSize: 50.0.ssp, fontFamily: fontName2),)
                            : FlutterStopWatch(
                          key: _key,
                          dbRendaMachin: widget.dbRendaMachin,
                          rendaSelectTimeValue: widget.rendaSelectTimeValue,
                          inputdata: widget.inputData,
                          numberScore: widget.beforeSore,
                        ),
                        SizedBox(
                          width: 20.0.h,
                        ),
                        //TODO QUIT
                        _quitButtonDisplay(),
                      ],
                    ),
                    //

                    (isPlayStart == false) ?
                       (widget.rendaSelectTimeValue == 2) ?  _countRendDispaly()
                       : Text(' Press any button \n' + ' to Start ', style: TextStyle(
                          fontSize: 45.0.ssp),)
                    : _countRendDispaly(),
                    _rendaButtonLine(),
                    _rendaButtonLine(),
                    _rendaButtonLine(),
                    _rendaButtonLine(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

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

  Future<void> _quitButtonProcess() async {
    isPlayTimeUpFlag = false;
    //
    if (isPlayStart == true && widget.rendaSelectTimeValue != 2) {
      _key.currentState.stopResetCounter();
    }
    //
    isPlayStart = false;
    if (widget.rendaSelectTimeValue == 2) {
      await widget.dbRendaMachin.scoreUpdateProcess(_counter, widget.inputData);

      Navigator.pop(
          context, _counter);
    } else {
      Navigator.pop(
          context, 0);
    }
    return;
  }

  Widget _quitButtonDisplay() {
    return MyCustomOutlineButton(
      key: _key2,
      text: 'QUIT',
      color: Colors.redAccent.withOpacity(0.3),
      onPressed: () => _quitButtonProcess(),
      redius1: 20.0.r,
      edge: 4.0.w,
      redius2: 15.0.r,
      fontsize: 55.0.ssp,
    );
  }

  Widget _rendaButton() {
    return MyCustomOutlineButton(
      key: new GlobalKey<MyCustomOutlineButtonState>(),
      text: '',
      color: Colors.redAccent.withOpacity(0.3),
      redius1: 20.0.r,
      edge: 6.0.w,
      redius2: 15.0.r,
      fontsize: 60.0.ssp,
      onPressed: () {
        setState(() {
          if (widget.rendaSelectTimeValue == 2) {
            isPlayStart = true;
              _counter++;
          } else {
            if (!_key.currentState.isTimeUpFlag && isPlayStart == true) {
              _counter++;
              _key.currentState.scoreCount = _counter;
            }
            if (_counter == 0) {
              isPlayStart = true;
              _key.currentState.startListenStr();
            }  //if (!_key.currentState.isTimeUpFlag) {
          }
        });
      },
    );
  }

  Widget _countRendDispaly() {
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 10.0.h,//15
          ),
          Text(
            _counter.toString(),
            style: TextStyle(fontSize: 70.0.ssp),
          ),
          SizedBox(
            height: 10.0.h, //15
          ),
        ],
      ),
    );
  }
}
