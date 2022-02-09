import 'package:cube_painter/cubes/unit_cube.dart';
import 'package:cube_painter/model/crop.dart';
import 'package:cube_painter/model/cube_info.dart';
import 'package:cube_painter/transform/grid_transform.dart';
import 'package:flutter/material.dart';

class SimpleCube extends StatelessWidget {
  final CubeInfo info;

  const SimpleCube({
    Key? key,
    required this.info,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Offset offset = gridToUnit(info.center);

    return Transform.translate(
      offset: offset,
      child: info.crop == Crop.c
          ? const UnitCube()
          : UnitCube(
        crop: info.crop,
      ),
    );
  }
}
