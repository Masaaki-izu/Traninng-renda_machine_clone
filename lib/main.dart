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
    SystemChrome.setEnabledSystemUIOverlays([]);
    return ScreenUtilInit(
      designSize: Size(411, 683),
      allowFontScaling: true,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
         builder: (context, widget) {
           return MediaQuery(
             data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
             child: widget,
           );
         },
         home: HomeScreen(),
      ),
    );
  }
}