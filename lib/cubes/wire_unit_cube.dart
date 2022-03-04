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
/// TODO CHANGE TO FINAL
Paint get _paintCacheBR => Paint()
  ..color = wireBottomRightColor
  ..style = PaintingStyle.stroke;

Paint get _paintCacheBL => Paint()
  ..color = wireBottomLeftColor
  ..style = PaintingStyle.stroke;

Paint get _paintCacheT => Paint()
  ..color = wireTopColor
  ..style = PaintingStyle.stroke;
