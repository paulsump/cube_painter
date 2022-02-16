import 'package:cube_painter/cubes/cube_sides.dart';
import 'package:cube_painter/data/crop.dart';
import 'package:flutter/material.dart';

class CropUnitCube extends StatelessWidget {
  final Crop crop;

  const CropUnitCube({Key? key, this.crop = Crop.c}) : super(key: key);

  @override
  Widget build(BuildContext context) => CustomPaint(
        painter: _Painter(cubeSides: getCubeSides(crop)),
      );
}

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
