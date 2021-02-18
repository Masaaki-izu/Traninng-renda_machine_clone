import 'package:flutter/material.dart';

//共通使用のボタンクラス
class MyCustomOutlineButton extends StatefulWidget {
  final String text;  //ボタンに表示するテキスト
  final VoidCallback onPressed; //押下時、呼び出す関数など
  final Color color;  //ボタンの色
  final double width; //ボタンの幅
  final double redius1;//飾りの角の削除の調整値
  final double edge;// ボタンの四方余白調整
  final double redius2;//ボタンの角の削除の調整値
  final double fontsize;//表示するテキストのフォントサイズ

  const MyCustomOutlineButton(
      {Key key, this.text, this.onPressed, this.color, this.width,
        this.redius1, this.edge, this.redius2, this.fontsize})
      : super(key: key);

  MyCustomOutlineButtonState createState() => MyCustomOutlineButtonState();
}

class MyCustomOutlineButtonState extends State<MyCustomOutlineButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width:  widget.width ,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red, width: 2.0),
          color: widget.color,
          borderRadius: BorderRadius.circular(widget.redius1), //8
        ),
        margin: EdgeInsets.all(widget.edge),
        child: RawMaterialButton(
          fillColor: widget.color,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.redius2),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            //child: FittedBox(
              //fit: BoxFit.contain,
             child: Text(
              widget.text,
              style: TextStyle(
                  fontFamily: 'Lalezar',
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                  fontSize: widget.fontsize),
            ),
          ),
          onPressed: widget.onPressed,
          ),
    );
  }
}

