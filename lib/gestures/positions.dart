import 'dart:ui';

import 'package:cube_painter/out.dart';
import 'package:cube_painter/persisted/position.dart';

const noWarn = out;

/// A holder for passing around cube positions.
/// Comparable with [operator ==]
class Positions {
  final List<Position> list;

  static const Positions empty = Positions(<Position>[]);

  const Positions(this.list);

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