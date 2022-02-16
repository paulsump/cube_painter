import 'package:cube_painter/cubes/cube_sides.dart';
import 'package:cube_painter/out.dart';
import 'package:flutter/material.dart';

const noWarn = [out];

class SimpleTile extends StatelessWidget {
  final Offset bottom;

  final double scale;

  const SimpleTile({
    Key? key,
    required this.bottom,
    required this.scale,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: bottom,
      child: Transform.scale(
        scale: scale,
        child: const _UnitTile(),
      ),
    );
  }
}

class _UnitTile extends StatelessWidget {
  const _UnitTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => const CustomPaint(painter: _Painter());
}

class _Painter extends CustomPainter {
  const _Painter();

  @override
  void paint(Canvas canvas, Size size) =>
      canvas.drawPath(Path()..addPolygon(topSide, true), _paintCache);

  @override
  bool shouldRepaint(_Painter oldDelegate) => false;
}

final Paint _paintCache = Paint()
  ..shader = const LinearGradient(
    colors: [Color(0xff2e8c86), Color(0xff2c778f)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  ).createShader(const Rect.fromLTRB(-0.9, -1.0, 0.9, 0.0))
  ..style = PaintingStyle.fill;

// const double dt = 0.1;
// const double t = 0.5;
// final colors= [getTweenBtoGColor(t - dt), getTweenBtoGColor(t + dt)];

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
