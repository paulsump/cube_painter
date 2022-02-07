import 'package:cube_painter/model/crop_direction.dart';
import 'package:cube_painter/shared/out.dart';
import 'package:cube_painter/shared/screen_transform.dart';
import 'package:cube_painter/widgets/brush.dart';
import 'package:cube_painter/widgets/cube.dart';
import 'package:cube_painter/widgets/grid.dart';
import 'package:cube_painter/widgets/transformed.dart';
import 'package:flutter/material.dart';

const noWarn = [out, Screen];

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
    // TODO instead of clip, use maths to not draw widgets outside screen

    return Stack(
      children: [
        Transformed(
          child: Stack(
            children: [
              const Grid(),
              ..._editBlock,
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

      final int n = takenCubes.length;
      const double t = 0.5;

      for (int i = 0; i < n; ++i) {
        //TODO maybe set anim speed
        _editBlock.add(Cube(
          key: UniqueKey(),
          center: takenCubes[i].center,
          crop: takenCubes[i].crop,
          start: (n - i) * t / n,
          end: 1.0,
        ));
      }

      setState(() {});
    }
  }
}
