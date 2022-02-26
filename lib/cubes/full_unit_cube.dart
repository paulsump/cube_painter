import 'package:cube_painter/colors.dart';
import 'package:cube_painter/cubes/cube_sides.dart';
import 'package:flutter/material.dart';

class FullUnitCube extends StatelessWidget {
  const FullUnitCube({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const CustomPaint(painter: _Painter());
}

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

final Paint _paintCacheBR = Paint()
  ..shader = const LinearGradient(
    begin: Alignment.bottomRight,
    end: Alignment.topLeft,
    colors: [top, br],
  ).createShader(const Rect.fromLTRB(0.0, -0.5, 0.9, 1.0))
  ..style = PaintingStyle.fill;

final Paint _paintCacheBL = Paint()
  ..shader = const LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [bl, top],
  ).createShader(const Rect.fromLTRB(-0.9, -0.5, 0.0, 1.0))
  ..style = PaintingStyle.fill;

final Paint _paintCacheT = Paint()
  ..shader = const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xffb16564), top],
  ).createShader(const Rect.fromLTRB(-0.9, -1.0, 0.9, 0.0))
  ..style = PaintingStyle.fill;
