import 'dart:io';

import 'package:cube_painter/out.dart';

Future<String> loadString({required String filePath}) async {
  File file = File(filePath);

  // TODO remove this - am i checking for it?
  if (!await file.exists()) {
    return '';
  }

  return await file.readAsString();
}

Future<void> saveString(
    {required String filePath, required String string}) async {
  try {
    File file = File(filePath);
    await file.writeAsString(string);
  } catch (e) {
    // TODO REMOVE persist.dart, this comment is wrong
    // works on devices
    // but doesn't work on windows chrome
    // test if it works on simulators
    out(e);
  }
}
