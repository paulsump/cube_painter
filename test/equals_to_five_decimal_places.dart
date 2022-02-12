import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const double toFiveDecimalPlaces = 0.00001;

bool equalsOffsetListToFiveDecimalPlaces(List<Offset> a, List<Offset> b) {
  final int n = a.length;

  if (n != b.length) {
    return false;
  }
  for (int i = 0; i < n; ++i) {
    if (!_equalsOffset5(a[i], b[i])) {
      return false;
    }
  }
  return true;
}

bool _equalsDouble5(double a, double b) {
  return (a - b).abs() < 0.00001;
}

bool _equalsOffset5(Offset a, Offset b) {
  return _equalsDouble5(a.dx, b.dx) && _equalsDouble5(a.dy, b.dy);
}
