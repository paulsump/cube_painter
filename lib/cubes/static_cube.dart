import 'dart:collection';

import 'package:cube_painter/cubes/crop_unit_cube.dart';
import 'package:cube_painter/cubes/full_unit_cube.dart';
import 'package:cube_painter/data/crop.dart';
import 'package:cube_painter/data/cube_info.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/transform/position_to_unit.dart';
import 'package:cube_painter/transform/unit_to_screen.dart';
import 'package:flutter/material.dart';

const noWarn = out;

class StaticCubes extends StatelessWidget {
  final List<StaticCube> staticCubes = [];

  StaticCubes({Key? key, required UnmodifiableListView<CubeInfo> cubeInfos})
      : super(key: key) {
    for (CubeInfo info in cubeInfos) {
      StaticCube(info: info);
    }
  }

  @override
  Widget build(BuildContext context) {
    // final cubeInfos = getCubeInfos(context, listen: true);

    return UnitToScreen(
      child: Stack(
        children: [
          ...staticCubes,
          // for (CubeInfo info in cubeInfos) StaticCube(info: info),
        ],
      ),
    );
  }
}

class StaticCube extends StatelessWidget {
  final CubeInfo info;

  const StaticCube({
    Key? key,
    required this.info,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Offset offset = positionToUnitOffset(info.center);

    return Transform.translate(
      offset: offset,
      child: info.crop == Crop.c
          ? const FullUnitCube()
          : CropUnitCube(crop: info.crop),
    );
  }
}
