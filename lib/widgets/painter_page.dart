import 'package:cube_painter/shared/enums.dart';
import 'package:cube_painter/shared/grid_point.dart';
import 'package:cube_painter/shared/grid_transform.dart';
import 'package:cube_painter/shared/out.dart';
import 'package:cube_painter/shared/screen_transform.dart';
import 'package:cube_painter/widgets/brush.dart';
import 'package:cube_painter/widgets/cube.dart';
import 'package:cube_painter/widgets/grid.dart';
import 'package:cube_painter/widgets/transformed.dart';
import 'package:cube_painter/widgets/unit_cube.dart';
import 'package:flutter/material.dart';

const noWarn = out;

class PainterPage extends StatefulWidget {
  const PainterPage({
    Key? key,
  }) : super(key: key);

  @override
  State<PainterPage> createState() => _PainterPageState();
}

class _PainterPageState extends State<PainterPage> {
  final List<Cube> _editBlock = [];

  @override
  Widget build(BuildContext context) {
//TODO don't draw widgets outside screen
    const point = GridPoint(1, 1);
//     //TODO RENAME
    final Offset gridStep = toOffset(point);
    for (var cube in _editBlock) {
      out(cube.center!);
    }
    out(gridStep);
    return Stack(
      children: [
        const Transformed(child: Grid()),
        // TODO USe Transformed instead
        Transform.scale(
          // scale: getZoomScale(context) / 2,
          scale: getZoomScale(context),
          child: Stack(
            children: [
              ..._editBlock,
            ],
          ),
        ),
        Transformed(
          child: Stack(
            children: [
              Transform.translate(
                offset: gridStep,
                child: const UnitCube(),
              ),
              // Transform.translate(
              //   offset: gridStep * 7,
              //   child: const Cube(crop: Crop.c),
              // ),
            ],
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
      _editBlock.addAll(takenCubes);
      setState(() {});
    }
  }
}
