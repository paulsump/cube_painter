import 'dart:io';

import 'package:cube_painter/out.dart';
import 'package:path_provider/path_provider.dart';

//TODO Persist shouldn't be a class
class Persisted {
  final String fileName;

  Persisted({required this.fileName});

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
      // out(file.path);
      // out(text);
    } catch (e) {
      // works on devices
      // doesn't work on windows chrome or simulators
      out(e);
    }
  }

  Future<String> _getFilePath() async {
    final Directory folder = await getApplicationDocumentsDirectory();

    final String path = folder.path;
    return '$path/$fileName';
  }

}
