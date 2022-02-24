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

  static Future<void> copyAllFromTo(
      String fromAssetFolderPath, String toAppFolderPath,
      {required String extensionReplacement}) async {
    final assetFilePaths = await getFilePaths(fromAssetFolderPath);

    for (String assetFilePath in assetFilePaths) {
      final assetFileName = assetFilePath.split(Platform.pathSeparator).last;

      final appFileName =
          assetFileName.replaceFirst('.json', extensionReplacement);

      final String appFilePath = '$toAppFolderPath$appFileName';
      File appFile = File(appFilePath);

      if (!await appFile.exists()) {
        out('copying $appFilePath');

        final String assetJson = await rootBundle.loadString(assetFilePath);
        await appFile.writeAsString(assetJson);
      }
    }
  }
}
