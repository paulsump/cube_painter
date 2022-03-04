import 'package:cube_painter/colors.dart';
import 'package:cube_painter/cubes/cube_sides.dart';
import 'package:flutter/material.dart';

/// a normal cube (not a [Slice])
/// 'unit' means that it has a size of 1.
/// This has been optimised more than [SliceUnitCube] at the moment
/// because there can be lots of these, but less [SliceUnitCube]s
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
// todo change colors
//todo remove linear gradient?
final Paint _paintCacheBR = Paint()
  ..shader = const LinearGradient(
    begin: Alignment.bottomRight,
    end: Alignment.topLeft,
    colors: [topColor, bottomRightColor],
  ).createShader(const Rect.fromLTRB(0.0, -0.5, 0.9, 1.0))
  ..style = PaintingStyle.stroke;

final Paint _paintCacheBL = Paint()
  ..shader = const LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [bottomLeftColor, topColor],
  ).createShader(const Rect.fromLTRB(-0.9, -0.5, 0.0, 1.0))
  ..style = PaintingStyle.stroke;

final Paint _paintCacheT = Paint()
  ..shader = const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xffb16564), topColor],
  ).createShader(const Rect.fromLTRB(-0.9, -1.0, 0.9, 0.0))
  ..style = PaintingStyle.stroke;
