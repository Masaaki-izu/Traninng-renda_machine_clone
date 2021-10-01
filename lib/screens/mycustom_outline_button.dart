import 'package:flutter/material.dart';

class MyCustomOutlineButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final double width;
  final double redius1;
  final double edge;
  final double redius2;
  final double fontsize;

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

