import 'dart:io';

import 'package:cube_painter/out.dart';
import 'package:path_provider/path_provider.dart';

class Persist {
  final String fileName;

  Persist({required this.fileName});

  Future<String> load() async {
    File file = File(await _getFilePath());
    // out(file.path);
    // file.delete();
    // return '';

    if (!file.existsSync()) {
      return '';
    }

    return await file.readAsString();
  }

  void save(String text) async {
    try {
      File file = File(await _getFilePath());
      file.writeAsString(text);
      out(file.path);
      out(text);
    } catch (e) {
      // doesn't work on windows or mac
      out(e);
    }
  }

  Future<String> _getFilePath() async {
    Directory folder = await getApplicationDocumentsDirectory();

    String path = folder.path;
    return '$path/$fileName';
  }
}
