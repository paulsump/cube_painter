import 'dart:io';

import 'package:cube_painter/out.dart';

Future<String> loadString({required String filePath}) async {
  File file = File(filePath);

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
  } catch (e) {
    // works on devices
    // but doesn't work on windows chrome
    // test if it works on simulators
    out(e);
  }
}
