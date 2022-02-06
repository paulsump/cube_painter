import 'package:cube_painter/shared/enums.dart';
import 'package:cube_painter/shared/out.dart';
import 'package:cube_painter/shared/screen_transform.dart';
import 'package:cube_painter/widgets/brush.dart';
import 'package:cube_painter/widgets/cube.dart';
import 'package:cube_painter/widgets/grid.dart';
import 'package:cube_painter/widgets/transformed.dart';
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
    // TODO instead of clip, use maths to not draw widgets outside screen
    return Stack(
      children: [
        const Transformed(child: Grid()),
        Transform.scale(
          scale: getZoomScale(context),
          child: Stack(
            children: [
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
      for (final cube in takenCubes) {
        _editBlock.add(Cube(
          key: UniqueKey(),
          center: cube.center,
          crop: cube.crop,
          start: true,
        ));
      }
      setState(() {});
    }
  }
}
