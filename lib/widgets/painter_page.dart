import 'package:cube_painter/shared/enums.dart';
import 'package:cube_painter/widgets/brush.dart';
import 'package:cube_painter/widgets/cube.dart';
import 'package:cube_painter/widgets/grid.dart';
import 'package:cube_painter/widgets/transformed.dart';
import 'package:flutter/material.dart';

class PainterPage extends StatelessWidget {
  const PainterPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
//TODO don't draw widgets outside screen
//     const point = GridPoint(1, 0);
//     final Offset offset = toOffset(point);
//     //TODO RENAME AND make as above
//     const Offset gridStep = Offset(W, H - 1);

    return Stack(
      children: [
        const Transformed(child: Grid()),
        // Transformed(
        //   child: Stack(
        //     children: [
        //       Transform.translate(
        //         offset: offset,
        //         child: const UnitCube(),
        //       ),
        //       const UnitCube(),
        //       Transform.translate(
        //         offset: offset * 7,
        //         child: const Cube(crop: Crop.c),
        //       ),
        //       Transform.translate(
        //         offset: gridStep,
        //         child: const UnitCube(),
        //       ),
        //       const UnitCube(),
        //       Transform.translate(
        //         offset: gridStep * 7,
        //         child: const Cube(crop: Crop.c),
        //       ),
        //     ],
        //   ),
        // ),
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
