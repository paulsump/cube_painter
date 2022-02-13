import 'package:cube_painter/colors.dart';
import 'package:cube_painter/cubes/cube_sides.dart';
import 'package:cube_painter/data/crop.dart';
import 'package:cube_painter/out.dart';
import 'package:flutter/material.dart';

const noWarn = out;

class UnitTile extends StatelessWidget {
  final double t;

  const UnitTile({
    Key? key,
    required this.t,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => CustomPaint(
        painter: _Painter(
          t: t,
          cubeSide: getCubeSides(Crop.c)[1],
        ),
      );
}

class _Painter extends CustomPainter {
  final CubeSide cubeSide;
  final double t;

  const _Painter({
    required this.t,
    required this.cubeSide,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // out( [getTweenBtoGColor(0.5 - dt), getTweenBtoGColor(0.5 + dt)],);
    // [Color(0xff2e8c86), Color(0xff2c778f)]
    // out(cubeSide.path.getBounds());
    // Rect.fromLTRB(-0.9, -1.0, 0.9, 0.0)
    canvas.drawPath(
        // cubeSide.path, cubeSide.getPaint( PaintingStyle.fill));
        // cubeSide.path,paintCache);
        cubeSide.path,
        _getGradientPaint(0.5, cubeSide.path, PaintingStyle.fill));
    // cubeSide.path, _getGradientPaint(t, cubeSide.path, PaintingStyle.fill));

    // canvas.drawPath(
    //     cubeSide.path,
    //     Paint()
    //       ..color = getColor(cubeSide.side)
    //       ..style = PaintingStyle.stroke);
  }

  @override
  bool shouldRepaint(_Painter oldDelegate) => false;
}

const double dt = 0.1;

final Paint paintCache = Paint()
  ..shader = const LinearGradient(
    colors: [Color(0xff2e8c86), Color(0xff2c778f)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  ).createShader(const Rect.fromLTRB(-0.9, -1.0, 0.9, 0.0))
  ..style = PaintingStyle.fill;

Paint _getGradientPaint(double t, Path path, PaintingStyle style) {
  return Paint()
    ..shader = _getGradient(t).createShader(path.getBounds())
    ..style = style;
}

LinearGradient _getGradient(double t) => LinearGradient(
      // colors: [getTweenBLtoTColor(t - dt), getTweenBLtoTColor(t + dt)],
      colors: [getTweenBtoGColor(t - dt), getTweenBtoGColor(t + dt)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
