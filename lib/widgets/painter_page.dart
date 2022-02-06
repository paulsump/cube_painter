import 'package:cube_painter/shared/enums.dart';
import 'package:cube_painter/shared/grid_transform.dart';
import 'package:cube_painter/shared/screen_transform.dart';
import 'package:cube_painter/widgets/brush.dart';
import 'package:cube_painter/widgets/cube.dart';
import 'package:cube_painter/widgets/grid.dart';
import 'package:cube_painter/widgets/unit_cube.dart';
import 'package:flutter/material.dart';

class PainterPage extends StatelessWidget {
  const PainterPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
//TODO don't draw widgets outside screen
    return Stack(
      children: [
        Transform.translate(
          // offset: Offset(Screen.width/2, Screen.height/2 ),
          offset: Offset(0, Screen.height),
          child: Transform.scale(
            scale: getZoomScale(context),
            child: Stack(
              children: [
                const Grid(),
                Transform.translate(
                  offset: gridStep,
                  child: const UnitCube(),
                ),
                const UnitCube(),
                Transform.translate(
                  offset: gridStep * 7,
                  child: const Cube(crop: Crop.dl),
                ),
              ],
            ),
          ),
        ),
        Brush(
          onStartPan: () {},
          onEndPan: _takeCubes,
          onTapUp: _takeCubes,
          erase: false,
          crop: Crop.c,
        ),
      ],
    );
  }

  void _takeCubes(List<Cube> takenCubes) {
    if (takenCubes.isNotEmpty) {
      // _takeEditBlock();
      // _editBlock.addAll(takenCubes);
      // setState(() {});
    }
  }
}
