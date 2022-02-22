import 'dart:math';

import 'package:cube_painter/colors.dart';
import 'package:cube_painter/cubes/static_cube.dart';
import 'package:cube_painter/data/cube_group.dart';
import 'package:cube_painter/data/cube_info.dart';
import 'package:cube_painter/data/persist.dart';
import 'package:cube_painter/transform/position_to_unit.dart';
import 'package:flutter/material.dart';

class ThumbButton extends StatelessWidget {
  const ThumbButton({Key? key}) : super(key: key);

  void tap(context) {
//TODO onTap, load
    final cubeGroupNotifier = getCubeGroupNotifier(context);
    cubeGroupNotifier.loadPersisted(Persisted(fileName: 'triangle'));
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class ImageThumb extends StatelessWidget {
  final String filePath;

  const ImageThumb({
    Key? key,
    required this.filePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image(image: AssetImage(filePath));
  }
}

class GeneratedThumb extends StatelessWidget {
  final CubeGroup cubeGroup;

  const GeneratedThumb({Key? key, required this.cubeGroup}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scoff = calcUnitScaleAndOffset();

    final scale = scoff[0];
    final offset = scoff[1];

    return Container(
      // color: Colors.transparent,
      color: backgroundColor,
      width: 99,
      height: 179,
      child: Transform.scale(
        scale: 111 / scale,
        child: Transform.translate(
          offset: const Offset(140, 90) - offset,
          child: StaticCubes(cubeGroup: cubeGroup),
        ),
      ),
    );
  }

  calcUnitScaleAndOffset() {
    double minX = 9999999;
    double minY = 9999999;

    double maxX = -9999999;
    double maxY = -9999999;

    for (CubeInfo info in cubeGroup.cubeInfos) {
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
