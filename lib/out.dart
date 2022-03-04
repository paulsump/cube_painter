import 'dart:math';

import 'package:flutter/material.dart';

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

void _out(String text) {
  debugPrint(text);
  //TODO LOG
}

double _decimalPlaces5(double val) => _decimalPlaces(val, 5);

double _decimalPlaces(double val, int places) {
  num mod = pow(10.0, places);
  return ((val * mod).round().toDouble() / mod);
}
