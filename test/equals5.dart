import 'package:flutter/material.dart';

bool equals5(Object a, Object b) {
  if (a is double) {
    return _equalsDouble5(a, b as double);
  } else if (a is Offset) {
    return _equalsOffset(a, b as Offset);
  } else if (a is List<Offset>) {
    return _equalsListOffset5(a, b as List<Offset>);
  } else {
    return a == b;
  }
}

bool _equalsDouble5(double a, double b) {
  return (a - b).abs() < 0.00001;
}

bool _equalsOffset(Offset a, Offset b) {
  return _equalsDouble5(a.dx, b.dx) && _equalsDouble5(a.dy, b.dy);
}

bool _equalsListOffset5(List<Offset> a, List<Offset> b) {
  final int n = a.length;

  if (n != b.length) {
    return false;
  }
  for (int i = 0; i < n; ++i) {
    if (!equals5(a[i], b[i])) {
      return false;
    }
  }
  return true;
}
