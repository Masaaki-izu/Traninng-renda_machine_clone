import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:renda_machine_clone/screens/backgroud_image_display.dart';
import 'home_screen.dart';
import 'mycustom_outline_button.dart';
import 'package:renda_machine_clone/db/db_renda_machin.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlayGameTimeUp extends StatefulWidget {
  final int rendaTimeValue;
  final int rendaCount;
  final String timeCount;
  final String inputData;
  final int numberScore;
  final DbRendaMachin dbRendaMachin;

  PlayGameTimeUp(
      {Key key, this.dbRendaMachin,this.rendaTimeValue, this.rendaCount, this.timeCount,this.inputData,this.numberScore})
      : super(key: key);

  @override
  PlayGameTimeUpState createState() => PlayGameTimeUpState();
}
//プレイ画面のタイムアップ
class PlayGameTimeUpState extends State<PlayGameTimeUp> {
  final GlobalKey<MyCustomOutlineButtonState> _key = GlobalKey();
  final GlobalKey<HomeScreenState> _key4 = GlobalKey();
  TextStyle textStyle = TextStyle(fontSize: 80.0.ssp, fontFamily: 'Bebas Neue');

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]); //ナビゲーションバーとステータスバーの非表示
    widget.dbRendaMachin.scoreSetProcess(widget.rendaCount,widget.inputData); //タイムアップ時、スコア等をデータベース更新
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
      key: _key4,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          BackgroundImageDisplay(),//背景画像表示
          SafeArea(
              child: Column(
                children: <Widget>[
                  //backgroundColor: Colors.transparent,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                          widget.timeCount,
                          style: textStyle),
                      SizedBox(
                        width: 20.0.w,
                      ),
                      _quitButtonDisplay(),
                    ],
                  ),
                  //連打カウント表示
                  _countRendDispaly(),
                  //Time Up 表示
                  _screenTimeUpDisplay(),
                ],
              ),
            ),
        ],
      ),
    );
  }
  // Time Up 表示
  Widget _screenTimeUpDisplay() {
    return Stack(
      children: <Widget>[
        SizedBox(
          height: 50.0.h,
        ),
        Text(
          'Time' + '\'' + 's' + ' UP!',
          style: TextStyle(fontSize: ScreenUtil().setSp(65.0)),
        ),
      ],
    );
  }
  //連打カウント表示
  Widget _countRendDispaly() {
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 15.0.h,
          ),
          Text(
            widget.rendaCount.toString(),
            style: TextStyle(fontSize: ScreenUtil().setSp(70.0)),
          ),
          SizedBox(
            height: 15.0.h,
          ),
        ],
      ),
    );
  }
  //QUITボタン押下時、前々画面に戻る
  _quitEndprocess() {
    var countScreen = 0;
    Navigator.popUntil(context, (_) => countScreen++ >= 2);
  }
  //QUIT ボタン表示
  Widget _quitButtonDisplay() {
    return  MyCustomOutlineButton(
      key: _key,  //_myCustumOutlineButton(
      text: 'QUIT',
      color: Colors.redAccent.withOpacity(0.3),
      onPressed: () => _quitEndprocess(),
      redius1: 20.0.r,
      edge: 4.0.w,
      redius2: 15.0.r,
      fontsize: 60.0.ssp,
    );
  }
}
