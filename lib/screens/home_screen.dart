import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:renda_machine_clone/screens/backgroud_image_display.dart';
import '../cs.dart';
import 'play_game_screen.dart';
import 'mycustom_outline_button.dart';
import 'package:renda_machine_clone/db/db_renda_machin.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const int inputCharMax = 10;

class HomeScreen extends StatefulWidget {
  final int score;
  final int returnRendaSelectTimeValue;
  final DbRendaMachin returnDbRendaMachin;

  HomeScreen(
      {Key key,
      this.returnDbRendaMachin,
      this.returnRendaSelectTimeValue,
      this.score})
      : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final GlobalKey<MyCustomOutlineButtonState> _key = GlobalKey();
  final DbRendaMachin dbRendaMachin = DbRendaMachin();
  final TextEditingController _textEditingController = TextEditingController();
  bool isNameInputData = false;
  bool isDbSameUnName = false;
  String inputDataString = '';

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
    _rankingDataRead();
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackgroundImageDisplay(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: SafeArea(
              child: Center(
                child: Column(
                  children: <Widget>[
                    _scoreDisplayPart(),
                    SizedBox(
                      height: 6.0.h,
                    ),
                    Text(
                      'Renda  ',
                      style: TextStyle(
                          fontSize: 53.0.ssp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Machine',
                      style: TextStyle(
                          fontSize: 53.0.ssp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 8.0.h,
                    ),
                    GestureDetector(
                      onTap: () {
                        _textEditingController.text = '';
                        _showInputDialog();
                        setState(() {});
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            width: 5.0.w,
                          ),
                          Container(
                            width: 0.7.sw,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border:
                                  Border.all(color: Colors.blue, width: 2.w),
                              borderRadius: BorderRadius.circular(8.0.r),
                            ),
                            padding: EdgeInsets.all(10.w),
                            child: Center(
                              child: Text(
                                inputDataString,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 22.0.ssp,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Icon(Icons.touch_app_sharp,
                              color: Colors.white,
                              size: 24.0.ssp,
                              textDirection: TextDirection.rtl),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8.0.h,
                    ),
                    (isNameInputData) ? _rendaTimeSelect() : Container(),
                    SizedBox(
                      height: 13.0.h,
                    ),
                    (isNameInputData)
                        ? _playButton(context)
                        : Container(
                            child: SizedBox(
                              height: 50.0.h,
                            ),
                          ),
                    SizedBox(
                      height: 35.0.ssp, //40.0.ssp
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        _gameDisplayExplanation(),
                        _rankingDisplay(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showInputDialog() async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        contentPadding: EdgeInsets.all(8.0.r),
        content: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                autofocus: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xffffffff),
                  hintText: 'Enter NickName',
                  hintStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 24.0.ssp,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 54.0.w),
                ),
                keyboardType: TextInputType.text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24.0.ssp,
                ),
                maxLength: inputCharMax,
                //maxLengthEnforced: false,
                controller: _textEditingController,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(inputCharMax),
                ],
              ),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                shape: MaterialStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                    side: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              child: Text(
                'CANCEL',
                style: TextStyle(fontSize: 20.0.ssp, fontFamily: fontName1),
              ),
              onPressed: () {
                Navigator.pop(context, '');
                SystemChrome.restoreSystemUIOverlays();
              }),
          TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                shape: MaterialStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                    side: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              child: Text(
                'OK',
                style: TextStyle(fontSize: 20.0.ssp, fontFamily: fontName1),
              ),
              onPressed: () {
                var name = _textEditingController.text;
                if (name.length > inputCharMax) {
                  name = name.substring(0, inputCharMax);
                }
                Navigator.pop(context, name);
                SystemChrome.restoreSystemUIOverlays();
              })
        ],
      ),
    ).then((value) {
      if (value != '') {
        setState(() {
          _inputTextCheck(value);
        });
      }
    });
  }

  void _inputTextCheck(String name) {
    if (name.isEmpty) {
      return;
    }
    if (name.isNotEmpty) {
      inputDataString = name;
      setState(() {
        isNameInputData = true;
        _inputNameDBCheck(inputDataString);
      });
    }
  }

  Future<bool> _inputNameDBCheck(String name) async {
    final List<Map<String, dynamic>> _isName =
        await dbRendaMachin.dbHelper.queryRowNameData(name);

    if (_isName.isEmpty) {
      dbRendaMachin.number10OfScore = 0;
      dbRendaMachin.number60OfScore = 0;
      dbRendaMachin.numberEndOfScore = 0;
      isDbSameUnName = true;
      setState(() {});
      return false;
    } else {
      dbRendaMachin.number10OfScore = _isName[0]['scoreTen'];
      dbRendaMachin.number60OfScore = _isName[0]['scoreSixty'];
      dbRendaMachin.numberEndOfScore = _isName[0]['scoreEndLess'];
      isDbSameUnName = false;
      setState(() {});
      return true;
    }
  }

  Widget _scoreDisplayPart() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0.r, right: 8.0.r, top: 8.0.r),
      child: Table(
        children: [
          TableRow(children: [
            Center(
              child: Text(
                selectGame[0],
                style: TextStyle(
                  fontSize: 20.0.ssp,
                ),
              ), //),
            ),
            Center(
              child: Text(
                selectGame[1],
                style: TextStyle(fontSize: 20.0.ssp),
              ), //),
            ),
            Center(
              child: Text(
                selectGame[2],
                style: TextStyle(fontSize: 20.0.ssp),
              ), //),
            ),
          ]),
          TableRow(children: [
            Center(
                child: Text(
              (isNameInputData)
                  ? dbRendaMachin.number10OfScore.toString()
                  : "----",
              style: TextStyle(
                fontSize: 25.0.ssp,
                color: Colors.white,
              ),
            )),
            Center(
                child: Text(
              (isNameInputData)
                  ? dbRendaMachin.number60OfScore.toString()
                  : "----",
              style: TextStyle(
                fontSize: 25.0.ssp,
                color: Colors.white,
              ),
            )),
            Center(
                child: Text(
              (isNameInputData)
                  ? dbRendaMachin.numberEndOfScore.toString()
                  : "----",
              style: TextStyle(
                fontSize: 25.0.ssp,
                color: Colors.white,
              ),
            )),
          ])
        ],
      ),
    );
  }

  Widget _rendaTimeSelect() {
    final List<Color> colorData = [Colors.blue, Colors.blue, Colors.blue];
    colorData[dbRendaMachin.rendaSelectTimeValue] = Colors.red;

    return Container(
      child: FittedBox(
        child: ButtonBar(
          alignment: MainAxisAlignment.center,
          children: <Widget>[
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.all(18.0),
                  side: BorderSide(width: 3.0, color: colorData[0]),
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(15.0))),
              onPressed: () {
                setState(() {
                  dbRendaMachin.rendaSelectTimeValue = 0;
                });
              },
              child: Text(
                selectGame[0],
                style: TextStyle(fontSize: 38.0.ssp, color: Colors.white),
              ),
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.all(18.0),
                  side: BorderSide(width: 3.0, color: colorData[1]),
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(15.0))),
              onPressed: () {
                setState(() {
                  dbRendaMachin.rendaSelectTimeValue = 1;
                });
              },
              child: Text(
                selectGame[1], //'60s',
                style: TextStyle(fontSize: 38.0.ssp, color: Colors.white),
              ),
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.all(18.0),
                  side: BorderSide(width: 3.0, color: colorData[2]),
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(15.0))),
              onPressed: () {
                setState(() {
                  dbRendaMachin.rendaSelectTimeValue = 2;
                });
              },
              child: Text(
                selectGame[2], //''ENDLESS,
                style: TextStyle(fontSize: 38.0.ssp, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _playButton(BuildContext context) {
    return Container(
      child: MyCustomOutlineButton(
        key: _key,
        text: 'PLAY',
        color: Colors.redAccent.withOpacity(0.3),
        onPressed: () => _playGameScreen(context),
        width: 0.8.sw,
        redius1: 30.0.r,
        edge: 2.0.w,
        redius2: 10.0.r,
        fontsize: 45.0.ssp,
      ),
    );
  }

  _playGameScreen(BuildContext context) async {
    int beforeScore;

    if (inputDataString.isEmpty) {
      return;
    }
    if (isDbSameUnName) {
      await dbRendaMachin.insert(
          nickName: inputDataString,
          timeCount: dbRendaMachin.rendaSelectTimeValue,
          score: 0);
      isDbSameUnName = false;
    }
    switch (dbRendaMachin.rendaSelectTimeValue) {
      case 0:
        beforeScore = dbRendaMachin.number10OfScore;
        break;
      case 1:
        beforeScore = dbRendaMachin.number60OfScore;
        break;
      case 2:
        beforeScore = dbRendaMachin.numberEndOfScore;
        break;
    }

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PlayGameScreen(
                  dbRendaMachin: dbRendaMachin,
                  rendaSelectTimeValue: dbRendaMachin.rendaSelectTimeValue,
                  beforeSore: beforeScore,
                  inputData: inputDataString,
                ))).then((value) => {
          setState(() {}),
        });
  }

  Widget _gameDisplayExplanation() {
    final double fontSize1 = 18.0;

    return Expanded(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var _count = 0; _count < strExplanation.length; _count++)
                Text(
                  strExplanation[_count],
                  style: TextStyle(
                    fontSize: fontSize1.ssp,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _rankingDisplay() {
    final double fontSize0 = 20.0;
    final double fontSize1 = 15.0;

    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        width: 0.5.sw,
        height: 0.3.sh,
        padding: EdgeInsets.only(left: 3.0.w),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red, width: 2.0.r),
        ),
        child: FittedBox(
          alignment: Alignment.topLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                ' Leaderboard',
                style: TextStyle(
                  fontSize: fontSize0.ssp,
                ),
              ),
              SizedBox(
                height: 1.0.h,
              ),
              for (var _count = 1; _count <= 10; _count++)
                (dbRendaMachin.scoreData[dbRendaMachin
                    .rendaSelectTimeValue][_count - 1] != '')
                    ? Text('$_count.' +
                    dbRendaMachin.scoreData[
                    dbRendaMachin.rendaSelectTimeValue][_count - 1],
                    style: TextStyle(fontSize: fontSize1.ssp,
                    ))
                    : Text(' ',
                  style: TextStyle(fontSize: fontSize1.ssp,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _rankingDataRead() async {
    await dbRendaMachin.setRankingData10s();
    await dbRendaMachin.setRankingData60s();
    await dbRendaMachin.setRankingDataEndless();
    setState(() {});
  }

}
