// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'package:cube_painter/cubes/cube_sides.dart';
import 'package:cube_painter/hue.dart';
import 'package:flutter/material.dart';

/// A wire frame whole cube of size of 1.
class WireUnitCube extends StatelessWidget {
  const WireUnitCube({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const CustomPaint(painter: _Painter());
}

/// The painter for [WireUnitCube]
class _Painter extends CustomPainter {
  const _Painter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
        Path()..addPolygon(bottomRightSideOffsets, true), _paintCacheBR);
    canvas.drawPath(
        Path()..addPolygon(bottomLeftSideOffsets, true), _paintCacheBL);
    canvas.drawPath(Path()..addPolygon(topSideOffsets, true), _paintCacheT);
  }

  @override
  bool shouldRepaint(_Painter oldDelegate) => false;
}

/// paint caches to speed up rendering
final Paint _paintCacheBR = Paint()
  ..color = Hue.wireBottomRight
  ..style = PaintingStyle.stroke;

final Paint _paintCacheBL = Paint()
  ..color = Hue.wireBottomLeft
  ..style = PaintingStyle.stroke;

final Paint _paintCacheT = Paint()
  ..color = Hue.wireTop
  ..style = PaintingStyle.stroke;
