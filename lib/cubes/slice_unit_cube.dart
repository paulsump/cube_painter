import 'package:cube_painter/cubes/cube_sides.dart';
import 'package:cube_painter/persisted/slice.dart';
import 'package:flutter/material.dart';

/// draws a sliced cube of unit (1) size
class SliceUnitCube extends StatelessWidget {
  final Slice slice;

  const SliceUnitCube({Key? key, required this.slice}) : super(key: key);

  @override
  Widget build(BuildContext context) => CustomPaint(
        painter: _Painter(cubeSides: getCubeSides(slice)),
      );
}

/// the painter for [SliceUnitCube]
class _Painter extends CustomPainter {
  final List<CubeSide> cubeSides;

  const _Painter({required this.cubeSides});

  @override
  void paint(Canvas canvas, Size size) {
    for (final cubeSide in cubeSides) {
      canvas.drawPath(
          cubeSide.path, cubeSide.getGradientPaint(PaintingStyle.fill));
    }
  }

  @override
  bool shouldRepaint(_Painter oldDelegate) => false;
}
