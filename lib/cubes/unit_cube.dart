import 'package:cube_painter/colors.dart';
import 'package:cube_painter/cubes/cube_sides.dart';
import 'package:cube_painter/cubes/side.dart';
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
          outline: crop == Crop.c,
          style: style,
        ),
      );
}

class _Painter extends CustomPainter {
  /// list of [Color,Path]
  final List<CubeSide> cubeSides;

  final PaintingStyle style;

  final bool outline;

  const _Painter({
    required this.cubeSides,
    required this.style,
    required this.outline,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final cubeSide in cubeSides) {
      canvas.drawPath(
          cubeSide.path,
          Paint()
            ..color = cubeSide.color
            ..style = style);

      if (true) {
        canvas.drawPath(
            cubeSide.path,
            Paint()
              ..color = outline
                  ? getColor(Side.t)
                  : cubeSide.color //Colors.deepPurpleAccent
              ..style = PaintingStyle.stroke);
      }
    }
  }

  @override
  bool shouldRepaint(_Painter oldDelegate) => false;
}
