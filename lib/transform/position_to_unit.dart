// Copyright (c) 2022, Paul Sumpner.  All rights reserved.

import 'package:cube_painter/persisted/position.dart';
import 'package:flutter/material.dart';

const root3over2 = 0.8660254037844386; // sqrt(3)/2

const double _w = root3over2;
const double _h = 0.5;

/// Convert from unit grid (Position)
/// to unit screen coordinate space (Offset).
/// Y is upwards in both coordinate spaces.
/// We need unit space because
/// it makes more sense than grid space because
/// it isn't skewed, so for example
/// standard vector maths works.
Offset positionToUnitOffset(Position position) =>
    Offset(_w * position.x, _h * position.x - position.y);

Offset unitOffsetToPositionOffset(Offset unitOffset) =>
    Offset(unitOffset.dx / _w, _h * unitOffset.dx / _w - unitOffset.dy);
