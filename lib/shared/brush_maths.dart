import 'dart:math';

import 'package:cube_painter/model/crop_direction.dart';
import 'package:cube_painter/model/grid_point.dart';
import 'package:cube_painter/shared/grid_transform.dart';
import 'package:cube_painter/shared/out.dart';
import 'package:cube_painter/widgets/cube.dart';
import 'package:flutter/material.dart';

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

  void extrudeTo(List<Cube> cubes, Offset toUnit) {
    final vecAndReverse = _calculateVectorAndReverseOrder(toUnit - _fromUnit);

    _vector = vecAndReverse[0];
    _reverseOrder = vecAndReverse[1];

    final Offset gridVector = unitToGrid(toUnit) - _fromGrid;
    _distance = gridVector.distance.round();

    cubes.clear();

    for (int i = 0; i < _distance; ++i) {
      final int d = _reverseOrder ? i - _distance : i;

      final center = _roundedFromGrid + _vector! * d;
      _addCube(cubes, center, Crop.c);
    }
  }

  void setCroppedCube(List<Cube> cubes, Offset point, Crop crop) {
    startFrom(point);

    cubes.clear();
    _addCube(cubes, _roundedFromGrid, crop);
  }

  void _addCube(List<Cube> cubes, GridPoint center, Crop crop) {
    const double t = 0.5;
    const double dt = 0.5;

    cubes.add(Cube(
      key: UniqueKey(),
      center: center,
      crop: crop,
      start: t - dt,
      // TODO FIX
      end: t + 0.15,
      pingPong: true,
    ));
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
