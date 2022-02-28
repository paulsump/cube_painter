import 'package:cube_painter/persisted/position.dart';
import 'package:flutter/material.dart';

const root3over2 = 0.86602540378; // root(3)/2

const double W = root3over2;
const double H = 0.5;

/// Convert from unit grid (Position)
/// to unit screen coordinate space (Offset).
/// Y is upwards in both coordinate spaces.
/// We need unit space because
/// it makes more sense than grid space because
/// it isn't skewed, so
/// standard vector maths works.

Offset unitOffsetToPositionOffset(Offset unitOffset) =>
    Offset(unitOffset.dx / W, H * unitOffset.dx / W - unitOffset.dy);

Offset positionToUnitOffset(Position position) =>
    Offset(W * position.x, H * position.x - position.y);
