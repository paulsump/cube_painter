import 'dart:convert';
import 'dart:io';

import 'package:cube_painter/out.dart';
import 'package:flutter/services.dart';

const noWarn = out;

class Assets {
  /// return map of filename + loaded string
  static Future<Map<String, String>> getStrings(String pathStartsWith) async {
    final manifestJson = await rootBundle.loadString('AssetManifest.json');

    final allFilePaths = jsonDecode(manifestJson).keys;
    final filePaths = <String, String>{};

    for (final String filePath in allFilePaths) {
      if (filePath.startsWith(pathStartsWith)) {
        final fileName = filePath.split(Platform.pathSeparator).last;

        filePaths[fileName] = await rootBundle.loadString(filePath);
      }
    }
    return filePaths;
  }

  static Future<void> copyAllFromTo(
      String fromAssetFolderPathStartsWith, String toAppFolderPath,
      {required String extensionReplacement}) async {
    final assetFilePaths = await getStrings(fromAssetFolderPathStartsWith);

    for (MapEntry asset in assetFilePaths.entries) {
      final assetFileName = asset.key;

      final appFileName =
          assetFileName.replaceFirst('.json', extensionReplacement);

      final String appFilePath = '$toAppFolderPath$appFileName';
      File appFile = File(appFilePath);

      if (!await appFile.exists()) {
        out('copying $appFilePath');

        await appFile.writeAsString(asset.value);
      }
    }
  }
}
