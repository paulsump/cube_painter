import 'package:cube_painter/colors.dart';
import 'package:cube_painter/cubes/cube_sides.dart';
import 'package:cube_painter/data/crop.dart';
import 'package:flutter/material.dart';

class Tile extends StatelessWidget {
  const Tile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => CustomPaint(
        painter: _Painter(
          cubeSide: getCubeSides(Crop.c)[1],
        ),
      );
}

class _Painter extends CustomPainter {
  final CubeSide cubeSide;

  const _Painter({
    required this.cubeSide,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(cubeSide.path, cubeSide.getPaint(PaintingStyle.fill));

    canvas.drawPath(
        cubeSide.path,
        Paint()
          ..color = getColor(cubeSide.side)
          ..style = PaintingStyle.stroke);
  }

  @override
  bool shouldRepaint(_Painter oldDelegate) => false;
}
