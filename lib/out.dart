import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// debugPrint any type of object, using toString()
/// or special case for a couple of types like List<Offset>
void out(Object object) {
  if (object is List<Offset>) {
    log('n = ${object.length}\nconst [');
    for (Offset offset in object) {
      log('Offset(${offset.dx},${offset.dy}),');
    }
    log(']');
  } else if (object is Offset) {
    log('${object.dx},${object.dy}');
  } else {
    log(object.toString());
  }
}

void clipError(String text) {
  out(text);
  //TODO append to error log
//TODO make a command that user can load the log and saveTolClip
  writeToClipboard(text);
}

void writeToClipboard(String text) =>
    Clipboard.setData(ClipboardData(text: text));

