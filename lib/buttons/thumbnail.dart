import 'dart:math';

import 'package:cube_painter/cubes/static_cube.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/persisted/cube_info.dart';
import 'package:cube_painter/persisted/sketch.dart';
import 'package:cube_painter/transform/position_to_unit.dart';
import 'package:flutter/material.dart';

const noWarn = out;

/// Auto generated (painted) thumbnail of a [Sketch]
/// Used on the buttons on the [PaintingsMenu]
/// 'Unit' means this thumbnail has size of 1
class UnitThumbnail extends StatelessWidget {
  final Sketch sketch;

  const UnitThumbnail({Key? key, required this.sketch}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final unitScaleAndOffset = calcUnitScaleAndOffset(sketch.cubeInfos);

    final unitScale = unitScaleAndOffset[0];
    final unitOffset = unitScaleAndOffset[1];

    return sketch.cubeInfos.isNotEmpty
        ? Transform.scale(
            scale: 1 / unitScale,
            child: Transform.translate(
              offset: -unitOffset,
              child: StaticCubes(sketch: sketch),
            ),
          )
        : Container();
  }
}

calcUnitScaleAndOffset(List<CubeInfo> cubeInfos) {
  double minX = 9999999;
  double minY = 9999999;

  double maxX = -9999999;
  double maxY = -9999999;

  for (CubeInfo info in cubeInfos) {
    final offset = positionToUnitOffset(info.center);

    if (minX > offset.dx) {
      minX = offset.dx;
    }
    if (maxX < offset.dx) {
      maxX = offset.dx;
    }
    if (minY > offset.dy) {
      minY = offset.dy;
    }
    if (maxY < offset.dy) {
      maxY = offset.dy;
    }
  }

  final double rangeX = maxX - minX;
  final double rangeY = maxY - minY;
  // out('$minX,$maxX,$rangeX');
  // out('$minY,$maxY,$rangeY');

  // Add 1 to scale for half the size of cube each side of center.
  return [1 + max(rangeX, rangeY), Offset(minX + maxX, minY + maxY) / 2];
}
