import 'dart:io';

import 'package:cube_painter/out.dart';

Future<String> loadString({required String filePath}) async {
  File file = File(filePath);

  // TODO check for empty string where i use this function?
  if (!await file.exists()) {
    out("File doesn't exist: $filePath");
    return '';
  }

  return await file.readAsString();
}

Future<void> saveString(
    {required String filePath, required String string}) async {
  assert(filePath.isNotEmpty);

  File file = File(filePath);
  await file.writeAsString(string);
}
