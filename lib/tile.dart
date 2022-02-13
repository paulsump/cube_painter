import 'package:cube_painter/colors.dart';
import 'package:cube_painter/cubes/cube_sides.dart';
import 'package:cube_painter/cubes/side.dart';
import 'package:cube_painter/data/crop.dart';
import 'package:flutter/material.dart';

class Tile extends StatelessWidget {
  final double t;

  const Tile({
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
    canvas.drawPath(cubeSide.path,
        _getGradientPaint(t, cubeSide.side, cubeSide.path, PaintingStyle.fill));

    canvas.drawPath(
        cubeSide.path,
        Paint()
          ..color = getColor(cubeSide.side)
          ..style = PaintingStyle.stroke);
  }

  @override
  bool shouldRepaint(_Painter oldDelegate) => false;
}

const double dt = 0.1;

LinearGradient _getGradient(double t, Side side) {
  switch (side) {
    case Side.t:
      return _gradientT(t);
    case Side.bl:
      return _gradientBL;
    case Side.br:
      return _gradientBR;
  }
}

Paint _getGradientPaint(double t, Side side, Path path, PaintingStyle style) {
  return Paint()
    ..shader = _getGradient(t, side).createShader(path.getBounds())
    ..style = style;
}

_gradientT(double t) => LinearGradient(
      // colors: [getColor(Side.bl), getColor(Side.br)],
      colors: [getTweenBLtoTColor(t - dt), getTweenBLtoTColor(t + dt)],
      // begin: Alignment.bottomCenter,
      // end: Alignment.topCenter,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

final _gradientBR = LinearGradient(
  colors: [getColor(Side.t), getColor(Side.br)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

final _gradientBL = LinearGradient(
  colors: [getColor(Side.bl), getColor(Side.t)],
  begin: Alignment.bottomLeft,
  end: Alignment.topRight,
);
