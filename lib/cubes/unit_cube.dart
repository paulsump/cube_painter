import 'package:cube_painter/cubes/cube_sides.dart';
import 'package:cube_painter/data/crop.dart';
import 'package:flutter/material.dart';

class UnitCube extends StatelessWidget {
  final Crop crop;
  final bool wire;

  const UnitCube({
    Key? key,
    this.crop = Crop.c,
    this.wire = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => CustomPaint(
        painter: _Painter(
          cubeSides: getCubeSides(crop),
          wire: wire,
        ),
      );
}

class _Painter extends CustomPainter {
  final List<CubeSide> cubeSides;

  final bool wire;

  const _Painter({
    required this.cubeSides,
    required this.wire,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final cubeSide in cubeSides) {
      canvas.drawPath(
          cubeSide.path,
          cubeSide.getGradientPaint(
              wire ? PaintingStyle.stroke : PaintingStyle.fill));
    }
  }

  @override
  bool shouldRepaint(_Painter oldDelegate) => false;
}
