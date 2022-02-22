import 'dart:io';

import 'package:cube_painter/out.dart';

Future<String> loadString({required String filePath}) async {
  File file = File(filePath);
  // file.delete();

  if (!file.existsSync()) {
    return '';
  }

  return await file.readAsString();
}

Future<void> saveString(
    {required String filePath, required String string}) async {
  try {
    File file = File(filePath);
    file.writeAsString(string);
    // out(file.path);
    // out(text);
  } catch (e) {
    // works on devices
    // doesn't work on windows chrome or simulators
    out(e);
  }
}
