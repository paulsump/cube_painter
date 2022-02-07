import 'package:cube_painter/model/crop_direction.dart';
import 'package:cube_painter/model/cube_info.dart';
import 'package:cube_painter/shared/grid_transform.dart';
import 'package:cube_painter/widgets/unit_cube.dart';
import 'package:flutter/material.dart';

class SimpleCube extends StatelessWidget {
  final CubeInfo info;

  const SimpleCube({Key? key, required this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Offset offset = gridToUnit(info.center);

    return Transform.translate(
      offset: offset,
      child: info.crop == Crop.c
          //TODO SimpleCube - opacity means not using const UnitCube
          ? const UnitCube()
          : CroppedUnitCube(crop: info.crop),
    );
  }
}
