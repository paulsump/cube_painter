import 'dart:convert';

import 'package:cube_painter/out.dart';
import 'package:flutter/services.dart';

const noWarn = out;

class Assets {
  static Future<Map<String, dynamic>> loadJson(String filePath) async {
    final String json = await rootBundle.loadString(filePath);
    Map<String, dynamic> map = jsonDecode(json);

    // out(map);
    return map;
  }

  static Future<Iterable<String>> getFilePaths(String folderPath) async {
    final manifestJson = await rootBundle.loadString('AssetManifest.json');

    final fileNames = jsonDecode(manifestJson)
        .keys
        .where((String key) => key.startsWith(folderPath + '/'));

    // out(fileNames);
    return fileNames;
  }

// //use like this
// await for (final json in Assets.loadAll('data_test')) {
//   cubeGroupNotifier.add(CubeGroup.fromJson(await json));
// }
// static Stream<Future<Map<String, dynamic>>> loadAll(
//     String folderPath) async* {
//   final filePaths = await getFilePaths(folderPath);
//   for (String filePath in filePaths) {
//     yield loadJson(filePath);
//   }
// }
}