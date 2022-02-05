import 'dart:math';

import 'package:flutter/material.dart';

void out(Object object) {
  if (object is List<Offset>) {
    debugPrint('n = ${object.length}\nconst [');
    for (Offset offset in object) {
      debugPrint('Offset(${_dp5(offset.dx)},${_dp5(offset.dy)}),');
    }
    debugPrint(']');
  } else if (object is Offset) {
    debugPrint('${object.dx},${object.dy}');
  } else {
    debugPrint(object.toString());
  }
}

double _dp5(double val) => _decimalPlaces(val, 5);

double _decimalPlaces(double val, int places) {
  num mod = pow(10.0, places);
  return ((val * mod).round().toDouble() / mod);
}
