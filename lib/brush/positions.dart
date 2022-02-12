import 'dart:ui';

import 'package:cube_painter/data/position.dart';
import 'package:cube_painter/out.dart';

const noWarn = out;

/// for passing around cube positions
class Positions {
  final list = <Position>[];

  @override
  bool operator ==(Object other) {
    if (other is! Positions) {
      return false;
    }

    final int n = list.length;

    if (n != other.list.length) {
      return false;
    }

    for (int i = 0; i < n; ++i) {
      if (list[i] != other.list[i]) {
        return false;
      }
    }
    return true;
  }

  @override
  int get hashCode => hashValues(list, 1);
}
