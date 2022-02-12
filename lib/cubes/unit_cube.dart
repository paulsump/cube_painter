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
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CubePainter(
        context: context,
        cubeSides: getCubeSides(crop),
        style: style,
      ),
    );
  }
}

class _CubePainter extends CustomPainter {
  /// list of [Color,Path]
  final List<CubeSide> cubeSides;

  final BuildContext context;

  final PaintingStyle style;

  const _CubePainter({
    required this.cubeSides,
    required this.context,
    required this.style,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _draw(canvas, style);
  }

  @override
  bool shouldRepaint(_CubePainter oldDelegate) => false;

  void _draw(Canvas canvas, PaintingStyle style) {
    for (final cubeSide in cubeSides) {
      canvas.drawPath(
          cubeSide.path,
          Paint()
            ..color = cubeSide.color
            ..style = style);
    }
  }
}
