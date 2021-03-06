// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'dart:ui';

import 'package:cube_painter/persisted/position.dart';

/// Though this is useful for passing around cube positions,
/// the reason it exists is mainly to
/// compare all the items inside with [operator ==].
class Positions {
  const Positions(this.list);

  final List<Position> list;
  static const Positions empty = Positions(<Position>[]);

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
