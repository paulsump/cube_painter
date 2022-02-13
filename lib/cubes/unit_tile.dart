import 'package:cube_painter/cubes/cube_sides.dart';
import 'package:cube_painter/out.dart';
import 'package:flutter/material.dart';

const noWarn = out;

class UnitTile extends StatelessWidget {
  const UnitTile({
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
    canvas.drawPath(Path()..addPolygon(topSide, true), paintCache);
  }

  @override
  bool shouldRepaint(_Painter oldDelegate) => false;
}

final Paint paintCache = Paint()
  ..shader = const LinearGradient(
    colors: [Color(0xff2e8c86), Color(0xff2c778f)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  ).createShader(const Rect.fromLTRB(-0.9, -1.0, 0.9, 0.0))
  ..style = PaintingStyle.fill;

// const double dt = 0.1;

// Paint _getGradientPaint(double t, Path path, PaintingStyle style) {
//   return Paint()
//     ..shader = _getGradient(t).createShader(path.getBounds())
//     ..style = style;
// }
//
// LinearGradient _getGradient(double t) => LinearGradient(
//       // colors: [getTweenBLtoTColor(t - dt), getTweenBLtoTColor(t + dt)],
//       colors: [getTweenBtoGColor(t - dt), getTweenBtoGColor(t + dt)],
//       begin: Alignment.topCenter,
//       end: Alignment.bottomCenter,
//     );
