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
//TODO don't draw widgets outside screen
//     const point = GridPoint(1, 1);
//     final Offset offset = toOffset(point);
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
        // Transformed(
        //   child: Stack(
        //     children: [
        //       Transform.translate(
        //         offset: offset,
        //         child: const UnitCube(),
        //       ),
        //       // Transform.translate(
        //       //   offset: offset * 7,
        //       //   child: const Cube(crop: Crop.c),
        //       // ),
        //     ],
        //   ),
        // ),
        Brush(
          onStartPan: () {},
          // onUpdatePan: _takeCubes,
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

      for (int i = 0; i < n; ++i) {
        //TODO maybe set anim speed or ammount so far value
        _editBlock.add(Cube(
          key: UniqueKey(),
          center: takenCubes[i].center,
          crop: takenCubes[i].crop,
          start: true,
        ));
      }
      // _editBlock.addAll(takenCubes);
      setState(() {});
    }
  }
}
