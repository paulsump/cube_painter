import 'dart:math';

import 'package:cube_painter/model/grid_point.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/transform/grid_transform.dart';
import 'package:cube_painter/widgets/brush/positions.dart';
import 'package:flutter/material.dart';

// TODO test
/// the maths for extruding blocks
class BrushMaths {
  /// dragged from point in grid space
  late Offset _fromUnit;
  late Offset _fromGrid;
  late GridPoint _roundedFromGrid;

  /// scale the drag vector to get the correct length
  int _distance = 0;

  /// unit drag vector
  late GridPoint? _vector;
  late bool _reverseOrder;

  void startFrom(Offset fromUnit) {
    _vector = null;

    _fromUnit = fromUnit;
    _fromGrid = unitToGrid(fromUnit);

    _roundedFromGrid = GridPoint(_fromGrid.dx.round(), _fromGrid.dy.round());
  }

  Positions extrudeTo(Offset toUnit) {
    final vecAndReverse = _calculateVectorAndReverseOrder(toUnit - _fromUnit);

    _vector = vecAndReverse[0];
    _reverseOrder = vecAndReverse[1];

    final Offset gridVector = unitToGrid(toUnit) - _fromGrid;
    _distance = gridVector.distance.round();

    var positions = Positions();

    for (int i = 0; i < _distance; ++i) {
      final int d = _reverseOrder ? i - _distance : i;

      positions.list.add(_roundedFromGrid + _vector! * d);
    }
    return positions;
  }

  GridPoint getPosition(Offset point) {
    startFrom(point);

    return _roundedFromGrid;
  }
}

List _calculateVectorAndReverseOrder(Offset newVector) {
  const double angle = -pi / 3;

  double direction = newVector.direction + angle / 2;
  direction /= angle;

  int dir = direction.round();

  switch (dir) {
    case 0:
      return [const GridPoint(1, 0), false];
    case 1:
      return [const GridPoint(-1, -1), true];
    case 2:
      return [const GridPoint(0, 1), false];
    case 3:
      return [const GridPoint(1, 0), true];
    case -3:
    case -2:
      return [const GridPoint(-1, -1), false];
    case -1:
      return [const GridPoint(0, 1), true];
  }
  out(dir);
  assert(false);
  return [];
}
