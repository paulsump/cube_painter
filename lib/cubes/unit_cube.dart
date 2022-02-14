import 'package:cube_painter/cubes/cube_sides.dart';
import 'package:cube_painter/data/crop.dart';
import 'package:flutter/material.dart';

class UnitCube extends StatelessWidget {
  final Crop crop;

  final PaintingStyle style;

  const UnitCube({
    Key? key,
    this.crop = Crop.c,
    this.style = PaintingStyle.fill,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => CustomPaint(
        painter: _Painter(
          cubeSides: getCubeSides(crop),
          style: style,
        ),
      );
}

class _Painter extends CustomPainter {
  final List<CubeSide> cubeSides;

  final PaintingStyle style;

  const _Painter({
    required this.cubeSides,
    required this.style,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final cubeSide in cubeSides) {
      canvas.drawPath(cubeSide.path, cubeSide.getGradientPaint(style));
    }
  }

  @override
  bool shouldRepaint(_Painter oldDelegate) => false;
}
