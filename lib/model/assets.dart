import 'dart:convert';

import 'package:cube_painter/out.dart';
import 'package:flutter/services.dart';

const noWarn = out;

class Assets {
  static const String folderPath = 'cube_groups';

  static loadAll() async {
    final filePaths = await getFilePaths();
    for (String filePath in filePaths) {
      await loadSong(filePath);
    }
  }

  static Future<Iterable<String>> getFilePaths() async {
    final manifestJson = await rootBundle.loadString('AssetManifest.json');

    final fileNames = jsonDecode(manifestJson)
        .keys
        .where((String key) => key.startsWith(folderPath));

    // out(fileNames);
    return fileNames;
  }

  static Future<Map<String, dynamic>> loadSong(String filePath) async {
    final String json = await rootBundle.loadString(filePath);
    out(json);
    Map<String, dynamic> map = jsonDecode(json);

    out(map);
    return map;
  }
}
