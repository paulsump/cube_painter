import 'dart:io';

import 'package:cube_painter/data/assets.dart';

//TODO MERge this file into assets and persist
List<String> getAllFilePathsSync(String folderPath) {
  final List<FileSystemEntity> fileEntities = Directory(folderPath).listSync();

  return List.generate(fileEntities.length, (i) => fileEntities[i].path);
}

Future<List<String>> getAllImagePaths() async {
  return Assets.getFilePaths('images');
}
