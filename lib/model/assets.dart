import 'dart:convert';

import 'package:cube_painter/out.dart';
import 'package:flutter/services.dart';

const noWarn = out;

class Assets {
  static const String folderPath = 'models';

  static loadAll() async {
    final filePaths = await getFilePaths();
    for (String filePath in filePaths) {
      await loadSong(filePath);
    }
  }

  static Future<List<String>> getFilePaths() async {
    final manifestJson = await rootBundle.loadString('AssetManifest.json');

    final fileNames = json.decode(manifestJson).keys.where(
          (String key) => key.startsWith(folderPath),
        );

    out(fileNames);
    return fileNames;
  }

  static Future<Map<String, dynamic>> loadSong(String filePath) async {
    final String response = await rootBundle.loadString(filePath);
    final map = await json.decode(response);

    out(map);
    return map;
  }
}
