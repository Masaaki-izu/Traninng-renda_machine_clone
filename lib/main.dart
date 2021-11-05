import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/screenutil_init.dart';
import 'package:renda_machine_clone/screens/home_screen.dart';
import 'input_storage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  MyApp({Key key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
    );
    return ScreenUtilInit(
      designSize: Size(411, 683),
      allowFontScaling: true,
      builder: () => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.dark(),
           builder: (context, widget) {
             return MediaQuery(
               data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
               child: widget,
             );
           },
           home: HomeScreen(inputStorage: InputStorage(),),
        ),
    );
  }
}