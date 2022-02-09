import 'dart:convert';

import 'package:cube_painter/out.dart';
import 'package:flutter/services.dart';

const noWarn = out;

class Assets {
  static const String folderPath = 'cube_groups';

  static Stream<Future<Map<String, dynamic>>> loadAll() async* {
    final filePaths = await getFilePaths();
    for (String filePath in filePaths) {
      yield loadJson(filePath);
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

  static Future<Map<String, dynamic>> loadJson(String filePath) async {
    final String json = await rootBundle.loadString(filePath);
    Map<String, dynamic> map = jsonDecode(json);

    // out(map);
    return map;
  }
}
