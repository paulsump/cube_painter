import 'package:cube_painter/colors.dart';
import 'package:cube_painter/cubes/cube_sides.dart';
import 'package:flutter/material.dart';

class Horizon extends StatelessWidget {
  const Horizon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const CustomPaint(painter: _Painter());
}

/// the painter for [Horizon]
class _Painter extends CustomPainter {
  const _Painter();

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()..addPolygon(quad, true);
    // canvas.drawPath(Path()..addPolygon(quad, true), _paintCacheBL);
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

/// TODO Responsive to screen size- magic numbers
/// these are based on my phone
const quad = [
  Offset(-1.4, 0.0),
  Offset(1.4, 0.0),
  Offset(1.4, 1.6),
  Offset(-1.4, 1.6),
];

final _gradientBottomTop = LinearGradient(
  colors: [getColor(Side.bl), getColor(Side.t)],
  begin: Alignment.bottomCenter,
  end: Alignment.topCenter,
);

// final Paint _paintCacheBL = Paint()
//   ..shader = const LinearGradient(
//     begin: Alignment.bottomLeft,
//     end: Alignment.topRight,
//     colors: [bl, top],
//   ).createShader(const Rect.fromLTRB(-0.9, -0.5, 0.0, 1.0))
//   ..style = PaintingStyle.fill;
