import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const String backGroundImageFile = 'assets/images/spaceimage.jpg';

//バックグランドイメージ表示
class BackgroundImageDisplay extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(backGroundImageFile),
          fit: BoxFit.cover,//最小の大きさまで拡大縮小する。対象の縦横比は変えない。
        ),
      ),
    );
  }
}
