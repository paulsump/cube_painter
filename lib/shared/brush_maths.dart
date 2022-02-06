import 'dart:math';

import 'package:cube_painter/shared/enums.dart';
import 'package:cube_painter/shared/grid_point.dart';
import 'package:cube_painter/shared/grid_transform.dart';
import 'package:cube_painter/shared/out.dart';
import 'package:cube_painter/widgets/cube.dart';
import 'package:flutter/material.dart';

// TODO before _cubes.clear(), remember cube.scale for each and copy to the new ones
// might need to just copy over the old ones in that position, so might need to store position

/// the maths for extruding blocks
class BrushMaths {
  /// dragged from point in grid space
  late Offset _from;
  late Offset _fromGrid;
  late GridPoint _roundedFrom;

  /// scale the drag vector to get the correct length
  int _distance = 0;

  /// unit drag vector
  late GridPoint? _vector;
  late bool _reverseOrder;

  void startFrom(Offset from) {
    _vector = null;

    _from = from;
    _fromGrid = toGrid(from);

    _roundedFrom = GridPoint(_fromGrid.dx.round(), _fromGrid.dy.round());
  }

  void extrudeTo(List<Cube> cubes, Offset to) {
    final vecAndReverse = _calculateVectorAndReverseOrder(to - _from);

    _vector = vecAndReverse[0];
    _reverseOrder = vecAndReverse[1];

    final Offset gridVector = toGrid(to) - _fromGrid;
    _distance = gridVector.distance.round();

    // cubes.clear();

    for (int i = 0; i < _distance; ++i) {
      final int d = _reverseOrder ? i - _distance : i;

      final center = _roundedFrom + _vector! * d;
      _addCube(cubes, center, Crop.c);
    }
  }

  void setCroppedCube(List<Cube> cubes, Offset point, Crop crop) {
    startFrom(point);

    cubes.clear();
    _addCube(cubes, _roundedFrom, crop);
  }

  void _addCube(List<Cube> cubes, GridPoint center, Crop crop) {
    for (final cube in cubes) {
      if (cube.center == center) {
        return;
      }
    }
    //TODO REmove others
    cubes.add(Cube(key: UniqueKey(), center: center, crop: crop));
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
