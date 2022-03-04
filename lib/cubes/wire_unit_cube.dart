import 'package:cube_painter/colors.dart';
import 'package:cube_painter/cubes/cube_sides.dart';
import 'package:flutter/material.dart';

/// A wire frame whole cube of size of 1.
class WireUnitCube extends StatelessWidget {
  const WireUnitCube({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const CustomPaint(painter: _Painter());
}

/// the painter for [WireUnitCube]
class _Painter extends CustomPainter {
  const _Painter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(Path()..addPolygon(bottomRightSide, true), _paintCacheBR);
    canvas.drawPath(Path()..addPolygon(bottomLeftSide, true), _paintCacheBL);
    canvas.drawPath(Path()..addPolygon(topSide, true), _paintCacheT);
  }

  @override
  bool shouldRepaint(_Painter oldDelegate) => false;
}

/// paint caches to speed up rendering
// todo change wire colors
//todo remove linear gradient?
final Paint _paintCacheBR = Paint()
  ..color = bottomRightColor
  ..style = PaintingStyle.stroke;

final Paint _paintCacheBL = Paint()
  ..color = bottomLeftColor
  ..style = PaintingStyle.stroke;

final Paint _paintCacheT = Paint()
  ..color = topColor
  ..style = PaintingStyle.stroke;
