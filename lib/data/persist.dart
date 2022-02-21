import 'package:path_provider/path_provider.dart';
import 'dart:io';

class Persist {
  static const String _fileName = "cubes1.csv";

  Future<String> load() async {
    File file = File(await _getFilePath());
    // file.delete();

    if (!file.existsSync()) {
      return '';
    }

    return await file.readAsString();
  }

  void save(String text) async {
    try {
      File file = File(await _getFilePath());
      file.writeAsString(text);
    } catch (e) {
      // doesn't work on windows or mac
    }
  }

  Future<String> _getFilePath() async {
    Directory folder = await getApplicationDocumentsDirectory();

    String path = folder.path;
    return '$path/$_fileName';
  }
}
