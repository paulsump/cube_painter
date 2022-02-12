import 'package:cube_painter/data/grid_point.dart';
import 'package:flutter/material.dart';

const root3over2 = 0.86602540378; // root(3)/2

const double W = root3over2;
const double H = 0.5;

/// Convert from unit grid (GridPoint)
/// to unit screen coordinate space (Offset).
/// Y is upwards in both coordinate spaces.
/// We need unit space because
/// it makes more sense than grid space because
/// it isn't skewed, so
/// standard vector maths works.

Offset unitToGrid(Offset u) => Offset(u.dx / W, H * u.dx / W - u.dy);

Offset gridToUnit(GridPoint g) => Offset(W * g.x, H * g.x - g.y);
