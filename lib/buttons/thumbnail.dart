import 'dart:math';

import 'package:cube_painter/cubes/static_cube.dart';
import 'package:cube_painter/persisted/cube_info.dart';
import 'package:cube_painter/persisted/sketch.dart';
import 'package:cube_painter/transform/position_to_unit.dart';
import 'package:flutter/material.dart';

/// Auto generated (painted) thumbnail of a [Sketch]
/// Used on the buttons on the [PaintingsMenu]
class Thumbnail extends StatelessWidget {
  final Sketch sketch;

  const Thumbnail({Key? key, required this.sketch}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final unitScaleAndOffset = calcUnitScaleAndOffset();

    final scale = unitScaleAndOffset[0];
    final offset = unitScaleAndOffset[1];

    return Container(
      color: Colors.transparent,

      /// TODO Responsive to screen size- magic numbers
      width: 99,
      height: 179,
      child: Transform.scale(
        scale: 111 / scale,
        child: Transform.translate(
          /// TODO Responsive to screen size- magic numbers
          offset: const Offset(47.5, 90) - offset,
          child: StaticCubes(sketch: sketch),
        ),
      ),
    );
  }

  calcUnitScaleAndOffset() {
    double minX = 9999999;
    double minY = 9999999;

    double maxX = -9999999;
    double maxY = -9999999;

    for (CubeInfo info in sketch.cubeInfos) {
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

    return [max(rangeX, rangeY), Offset(minX + maxX, minY + maxY) / 2];
  }
}
