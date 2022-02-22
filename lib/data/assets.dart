import 'dart:convert';
import 'dart:io';

import 'package:cube_painter/data/persist.dart';
import 'package:cube_painter/out.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

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

  static Future<void> copyAllFromTo(
      String fromAssetFolderPath, String toAppFolderPath) async {
    final filePaths = await getFilePaths(fromAssetFolderPath);

    final Directory appFolder = await getApplicationDocumentsDirectory();

    for (String filePath in filePaths) {
      final String json = await rootBundle.loadString(filePath);

      final fileName = filePath.split('/').last;
      final String path = appFolder.path;

      await saveString(filePath: '$path/$fileName', string: json);
    }
  }
}
