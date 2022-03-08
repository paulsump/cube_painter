import 'package:cube_painter/cubes/cube_sides.dart';
import 'package:cube_painter/persisted/slice.dart';
import 'package:flutter/material.dart';

/// Draws a sliced cube of unit (1) size.
class SliceUnitCube extends StatelessWidget {
  const SliceUnitCube({Key? key, required this.slice}) : super(key: key);

  final Slice slice;

  @override
  Widget build(BuildContext context) => CustomPaint(
        painter: _Painter(cubeSides: getCubeSides(slice)),
      );
}

/// The painter for [SliceUnitCube].
class _Painter extends CustomPainter {
  const _Painter({required this.cubeSides});

  final List<CubeSide> cubeSides;

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
