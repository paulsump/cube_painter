import 'dart:convert';
import 'dart:io';

import 'package:cube_painter/out.dart';
import 'package:flutter/services.dart';

const noWarn = out;

class Assets {
  static Future<Map<String, dynamic>> loadJson(String filePath) async {
    final String json = await rootBundle.loadString(filePath);

    Map<String, dynamic> map = jsonDecode(json);
    return map;
  }

  static Future<List<String>> getFilePaths(String folderPath) async {
    final manifestJson = await rootBundle.loadString('AssetManifest.json');

    final fileNames = jsonDecode(manifestJson)
        .keys
        .where((String key) => key.startsWith(folderPath + '/'));

    return fileNames.toList();
  }

  static Stream<Future<Map<String, dynamic>>> loadAll(
      String folderPath) async* {
    final filePaths = await getFilePaths(folderPath);

    for (String filePath in filePaths) {
      yield loadJson(filePath);
    }
  }

  static void copyAllFromTo(
      String fromAssetFolderPath, String toAppFolderPath) async {
    final filePaths = await getFilePaths(fromAssetFolderPath);

    for (String filePath in filePaths) {
      File file = File(filePath);
      out(file.path.split('/').last);
      out('$toAppFolderPath/${file.path.split('/').last}');
      //copy
    }
  }
}
