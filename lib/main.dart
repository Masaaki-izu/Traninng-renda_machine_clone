import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/screenutil_init.dart';
import 'package:renda_machine_clone/db/db_renda_machin.dart';
import 'package:renda_machine_clone/screens/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  MyApp({Key key}): super(key: key);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);  //ステータスバー、ナビゲーション バー　非表示
    return ScreenUtilInit(        //画面サイズ対応　構築のための設定
      designSize: Size(411, 683), //画面デザインの幅、高さを設定　（603 -> 683）
      allowFontScaling: true,   //フォントサイズのスケーリング TODO: true・falseにしても、変わらない？
      child: MaterialApp(
        debugShowCheckedModeBanner: false,  //右上のデバッグ帯を非表示
        theme: ThemeData.dark(),            //ダークモードに設定
         builder: (context, widget) {       //TextウィジェットのパラメータtextScaleFactorに1.0を渡している
           return MediaQuery(
             //
             data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
             child: widget,
           );
         },
         home: HomeScreen(),  //連打マシーンのホーム画面へ
      ),
    );
  }
}