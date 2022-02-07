import 'dart:ui';

import 'package:cube_painter/model/grid_point.dart';
import 'package:cube_painter/out.dart';

const noWarn = out;

/// for passing around cube positions
class Positions {
  final list = <GridPoint>[];

  @override
  bool operator ==(Object other) {
    if (other is! Positions) {
      return false;
    }
    out('hi');
    // return list == other.list;
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
