import 'package:cube_painter/shared/grid_point.dart';
import 'package:flutter/material.dart';

const root3over2 = 0.86602540378; // root(3)/2
const double W = root3over2;
const double H = 0.5;
// const double W = 1;
// const double H = 0;

/// Convert from unit grid (GridPoint)
/// to unit screen coordinate space (Offset).
/// Y is upwards in both coordinate spaces.
/// We need unit space because
/// it makes more sense than grid space because
/// it isn't skewed, so
/// standard vector maths works.
double _gridx(double x) => x / W;

double _gridy(Offset offset) => H * offset.dx / W - offset.dy;

//TODO coord space - rename to unitToGrid
Offset toGrid(Offset offset) => Offset(_gridx(offset.dx), _gridy(offset));

//TODO coord space - rename to gridToUnit
Offset toOffset(GridPoint point) => Offset(
      W * point.x,
      H * point.x - point.y,
    );

