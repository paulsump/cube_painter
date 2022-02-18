import 'dart:math';

import 'package:cube_painter/brush/positions.dart';
import 'package:cube_painter/data/position.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/transform/position_to_unit.dart';
import 'package:flutter/material.dart';

/// the maths for extruding blocks
class BrushMaths {
  /// dragged from point in grid space
  late Offset _fromUnit;
  late Offset _fromPositionOffset;
  late Position _fromPosition;

  /// scale the drag vector to get the correct length
  int _distance = 0;

  /// unit drag vector
  late Position? _vector;
  late bool _reverseOrder;

  void startFrom(Offset fromUnit) {
    _vector = null;

    _fromUnit = fromUnit;
    _fromPositionOffset = unitOffsetToPositionOffset(fromUnit);

    _fromPosition = Position(
        _fromPositionOffset.dx.round(), _fromPositionOffset.dy.round());
  }

  Positions extrudeTo(Offset toUnit) {
    final vecAndReverse = _calculateVectorAndReverseOrder(toUnit - _fromUnit);

    _vector = vecAndReverse[0];
    _reverseOrder = vecAndReverse[1];

    final Offset gridVector =
        unitOffsetToPositionOffset(toUnit) - _fromPositionOffset;

    double distance = gridVector.distance;

    if (_vector!.x == _vector!.y) {
      // for Position(1,1) and Position(-1,-1) are longer vectors than (1,0) etc
      const root2 = 1.4142135623730950;
      distance /= root2;
    }

    _distance = distance.round();
    return Positions(List.generate(
        // _reverseOrder ? _distance + 1 : _distance,
        _distance,
        (i) =>
        _fromPosition +
            _vector! * (_reverseOrder ? i - _distance + 1 : i)));
  }

  Position getPosition(Offset unitOffset) {
    startFrom(unitOffset);

    return _fromPosition;
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
