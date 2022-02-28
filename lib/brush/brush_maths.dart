import 'dart:math';

import 'package:cube_painter/brush/positions.dart';
import 'package:cube_painter/persisted/position.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/transform/position_to_unit.dart';
import 'package:flutter/material.dart';

/// Used by [Brush],
/// this is the maths for placing lines of cubes.
class BrushMaths {
  /// dragged start point in grid space
  late Offset _startUnit;
  late Offset _startPositionOffset;
  late Position _startPosition;

  /// scale the drag vector to get the correct length
  int _distance = 0;

  /// unit drag vector
  late Position? _vector;
  late bool _reverseOrder;

  Position get startPosition => _startPosition;

  void calcStartPosition(Offset startUnit) {
    _vector = null;

    _startUnit = startUnit;
    _startPositionOffset = unitOffsetToPositionOffset(startUnit);

    _startPosition = Position(
        _startPositionOffset.dx.round(), _startPositionOffset.dy.round());
  }

  Positions calcPositionsUpToEndPosition(Offset endUnit) {
    final vectorAndReverse =
        _calculateVectorAndReverseOrder(endUnit - _startUnit);

    _vector = vectorAndReverse[0];
    _reverseOrder = vectorAndReverse[1];

    final Offset gridVector =
        unitOffsetToPositionOffset(endUnit) - _startPositionOffset;

    double distance = gridVector.distance;

    if (_vector!.x == _vector!.y) {
      // for Position(1,1) and Position(-1,-1) are longer vectors than (1,0) etc
      const root2 = 1.4142135623730950;
      distance /= root2;
    }

    _distance = distance.round();
    return Positions(
      List.generate(
          _distance,
          (i) =>
              _startPosition +
              _vector! * (_reverseOrder ? i - _distance + 1 : i)),
    );
  }
}

List _calculateVectorAndReverseOrder(Offset newVector) {
  const double angle = -pi / 3;

  double direction = newVector.direction + angle / 2;
  direction /= angle;

  final int dir = direction.round();

  switch (dir) {
    case 0:
      return [const Position(1, 0), false];
    case 1:
      return [const Position(-1, -1), true];
    case 2:
      return [const Position(0, 1), false];
    case 3:
      return [const Position(1, 0), true];
    case -3:
    case -2:
      return [const Position(-1, -1), false];
    case -1:
      return [const Position(0, 1), true];
  }
  out(dir);
  assert(false);
  return [];
}
