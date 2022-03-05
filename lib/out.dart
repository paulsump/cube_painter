import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// debugPrint any type of object, using toString()
/// or special case for a couple of types like List<Offset>
void out(Object object) {
  if (object is List<Offset>) {
    _out('n = ${object.length}\nconst [');
    for (Offset offset in object) {
      _out(
          'Offset(${_decimalPlaces5(offset.dx)},${_decimalPlaces5(offset.dy)}),');
    }
    _out(']');
  } else if (object is Offset) {
    _out('${object.dx},${object.dy}');
  } else {
    _out(object.toString());
  }
}

void _out(String text) => debugPrint(text);

void clipError(String text) {
  out(text);
  //TODO append to error log
//TODO make a command that user can load the log and saveTolClip
  saveToClipboard(text);
}

void saveToClipboard(String text) =>
    Clipboard.setData(ClipboardData(text: text));

double _decimalPlaces5(double val) => _decimalPlaces(val, 5);

double _decimalPlaces(double val, int places) {
  num mod = pow(10.0, places);
  return ((val * mod).round().toDouble() / mod);
}
