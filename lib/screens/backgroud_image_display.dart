import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const String backGroundImageFile = 'assets/images/spaceimage.jpg';

class BackgroundImageDisplay extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(backGroundImageFile),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
