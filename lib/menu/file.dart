import 'dart:io';

import 'package:cube_painter/data/assets.dart';
import 'package:path_provider/path_provider.dart';

List<String> getAllFilePaths(String folderPath) {
  final List<FileSystemEntity> fileEntities = Directory(folderPath).listSync();

  return List.generate(fileEntities.length, (i) => fileEntities[i].path);
}

Future<List<String>> getAllPersistedPaths() async {
  final Directory folder = await getApplicationDocumentsDirectory();
  return getAllFilePaths(folder.path);
}

Future<List<String>> getAllImagePaths() async {
  return Assets.getFilePaths('images');
}
