// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'package:cube_painter/hue.dart';
import 'package:cube_painter/transform/screen_adjust.dart';
import 'package:cube_painter/transform/unit_to_screen.dart';
import 'package:flutter/material.dart';

/// A simple quad, representing the ground.
class Horizon extends StatelessWidget {
  const Horizon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => UnitToScreen(
    child: Transform.scale(
      scale: screenAdjust(0.1, context),
      child: const CustomPaint(painter: _Painter()),
    ),
  );
}

/// The painter for [Horizon]
class _Painter extends CustomPainter {
  const _Painter();

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()..addPolygon(_rectangleOffsets, true);
    canvas.drawPath(path, getGradientPaint(PaintingStyle.fill, path));
  }

  @override
  bool shouldRepaint(_Painter oldDelegate) => false;
}

Paint getGradientPaint(PaintingStyle style, Path path) {
  // out(path.getBounds());
  return Paint()
    ..shader = _gradientBottomTop.createShader(path.getBounds())
    ..style = style;
}

/// The width is way wider than it needs to be,
/// but it doesn't matter since there's no gradient on it.
const _rectangleOffsets = [
  Offset(-2, 0.0),
  Offset(2, 0.0),
  Offset(2, 1.0),
  Offset(-2, 1.0),
];

final _gradientBottomTop = LinearGradient(
  colors: [Hue.top, Hue.horizon],
  begin: Alignment.bottomCenter,
  end: Alignment.topCenter,
);
