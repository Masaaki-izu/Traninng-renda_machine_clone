import 'dart:io';
import 'package:path_provider/path_provider.dart';

final fileName = 'inputName.txt';
final gameNumberFile = 'gameNumber.txt';
final gameDir = 'playGame';

class InputStorage {
  static String appPath = '';
  static String content = '';
  static String gameNumber = '0';
  Directory appDirectory;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<void>checkDirFunc() async{
    final String localPath = await _localPath;
    appPath = '$localPath/$gameDir';
    appDirectory = Directory(appPath);
    bool isDir = await appDirectory.existsSync();

    if (isDir == false) {
      await appDirectory.create(recursive: true);
    }
  }

  Future<String> fileCheckFunc() async{
    bool isCheckFile = false;

    await checkDirFunc();
    final file = File('$appPath/$fileName');
    bool isFile = file.existsSync();
    (isFile)
        ?  content = await  file.readAsString()
       : await file.writeAsString(content);
    final file2 = File('$appPath/$gameNumberFile');
    bool isFile2 = file2.existsSync();
    (isFile2)
        ? gameNumber  = await  file2.readAsString()
        : await file2.writeAsString(gameNumber);
    if (content != '')
      return content + ',' + gameNumber;
    else
      return content;
  }

  Future<void> readInputText() async {
    try {
      final file = File('$appPath/$fileName');
      content = await file.readAsString();
    } catch (e) {
      //content = '';
      return;
    }
  }

  Future<void> writeInputText(String inputText) async {
    final file = File('$appPath/$fileName');
    await file.writeAsString(inputText);
  }

  Future<void> readGameNumber() async {
    try {
      final file2 = File('$appPath/$gameNumberFile');
      gameNumber = await file2.readAsString();
    } catch (e) {
      //content = '';
      return;
    }
  }

  Future<void> writeGameNumber(String gameNumberText) async {
    final file2 = File('$appPath/$gameNumberFile');
    await file2.writeAsString(gameNumberText);
  }
}
