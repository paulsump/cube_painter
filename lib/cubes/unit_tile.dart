import 'package:cube_painter/colors.dart';
import 'package:cube_painter/cubes/cube_sides.dart';
import 'package:cube_painter/data/crop.dart';
import 'package:flutter/material.dart';

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
    canvas.drawPath(
        cubeSide.path, _getGradientPaint(t, cubeSide.path, PaintingStyle.fill));

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
