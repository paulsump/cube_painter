import 'package:cube_painter/cubes/cube_sides.dart';
import 'package:flutter/material.dart';

class SimpleUnitCube extends StatelessWidget {
  const SimpleUnitCube({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => const CustomPaint(
        painter: _Painter(),
      );
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
    colors: [Color(0xfff07f7e), Color(0xffffd8d6)],
  ).createShader(const Rect.fromLTRB(0.0, -0.5, 0.9, 1.0))
  ..style = PaintingStyle.fill;

final Paint _paintCacheBL = Paint()
  ..shader = const LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [Color(0xff543e3d), Color(0xfff07f7e)],
  ).createShader(const Rect.fromLTRB(-0.9, -0.5, 0.0, 1.0))
  ..style = PaintingStyle.fill;

final Paint _paintCacheT = Paint()
  ..shader = const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xffb16564), Color(0xfff07f7e)],
  ).createShader(const Rect.fromLTRB(-0.9, -1.0, 0.9, 0.0))
  ..style = PaintingStyle.fill;

// br
// I/flutter (11159): LinearGradient(begin: Alignment.bottomRight, end: Alignment.topLeft, colors: [Color(0xfff07f7e), Color(0xffffd8d6)], tileMode: TileMode.clamp)
// I/flutter (11159): Rect.fromLTRB(0.0, -0.5, 0.9, 1.0)
// I/flutter (11159): LinearGradient(begin: Alignment.bottomLeft, end: Alignment.topRight, colors: [Color(0xff543e3d), Color(0xfff07f7e)], tileMode: TileMode.clamp)
// I/flutter (11159): Rect.fromLTRB(-0.9, -0.5, 0.0, 1.0)
// I/flutter (11159): LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xffb16564), Color(0xfff07f7e)], tileMode: TileMode.clamp)
// I/flutter (11159): Rect.fromLTRB(-0.9, -1.0, 0.9, 0.0)
