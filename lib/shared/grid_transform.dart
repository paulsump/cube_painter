import 'package:cube_painter/shared/grid_point.dart';
import 'package:flutter/material.dart';

const root3over2 = 0.86602540378; // root(3)/2
const double W = root3over2;
const double H = 0.5;
// const double W = 1;
// const double H = 0;

/// convert from unit grid where y is up (Coord)
/// to unit screen space (Offset)
double _gridx(double x) => x / W;
double _gridy(Offset offset) => H * offset.dx / W - offset.dy;

Offset toGrid(Offset offset) => Offset(_gridx(offset.dx), _gridy(offset));

// TODO RENAME toScreen?
Offset toOffset(GridPoint point) => Offset(
      W * point.x,
      H * point.x - point.y,
    );

