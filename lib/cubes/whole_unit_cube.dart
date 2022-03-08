import 'package:cube_painter/cubes/cube_sides.dart';
import 'package:cube_painter/hue.dart';
import 'package:cube_painter/out.dart';
import 'package:flutter/material.dart';

const noWarn = out;

/// A whole cube (not a [Slice]) of size of 1.
/// This has been optimised more than [SliceUnitCube] at the moment
/// because there can be lots of these, but less [SliceUnitCube]s
class WholeUnitCube extends StatelessWidget {
  const WholeUnitCube({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const CustomPaint(painter: _Painter());
}

/// The painter for [WholeUnitCube]
class _Painter extends CustomPainter {
  const _Painter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(_pathBR, _paintCacheBR);
    canvas.drawPath(_pathBL, _paintCacheBL);
    canvas.drawPath(_pathT, _paintCacheT);
  }

  @override
  bool shouldRepaint(_Painter oldDelegate) => false;
}

final _pathBR = Path()..addPolygon(bottomRightSideOffsets, true);
final _pathBL = Path()..addPolygon(bottomLeftSideOffsets, true);
final _pathT = Path()..addPolygon(topSideOffsets, true);

/// paint caches to speed up rendering
final Paint _paintCacheBR = Paint()
  ..shader = const LinearGradient(
    begin: Alignment.bottomRight,
    end: Alignment.topLeft,
    colors: [Hue.top, Hue.bottomRight],
  ).createShader(const Rect.fromLTRB(0.0, -0.5, 0.9, 1.0))
  ..style = PaintingStyle.fill;

final Paint _paintCacheBL = Paint()
  ..shader = const LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [Hue.bottomLeft, Hue.top],
  ).createShader(const Rect.fromLTRB(-0.9, -0.5, 0.0, 1.0))
  ..style = PaintingStyle.fill;

final Paint _paintCacheT = Paint()
  ..shader = const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Hue.wholeCubeTopTop, Hue.top],
  ).createShader(const Rect.fromLTRB(-0.9, -1.0, 0.9, 0.0))
  ..style = PaintingStyle.fill;
