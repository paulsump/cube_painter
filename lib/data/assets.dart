import 'dart:convert';
import 'dart:io';

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

  static Future<void> copyAllFromTo(
      String fromAssetFolderPath, String toAppFolderPath) async {
    final assetFilePaths = await getFilePaths(fromAssetFolderPath);

    final Directory appFolder = await getApplicationDocumentsDirectory();
    final String appFolderPath = '${appFolder.path}${Platform.pathSeparator}';

    for (String assetFilePath in assetFilePaths) {
      final fileName = assetFilePath.split(Platform.pathSeparator).last;

      final String appFilePath = '$appFolderPath$fileName';
      File appFile = File(appFilePath);

      if (!await appFile.exists()) {
        out('copying $appFilePath');

        final String assetJson = await rootBundle.loadString(assetFilePath);
        await appFile.writeAsString(assetJson);
      }
    }
  }
}
