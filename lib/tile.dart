import 'package:cube_painter/colors.dart';
import 'package:cube_painter/cubes/cube_sides.dart';
import 'package:cube_painter/cubes/side.dart';
import 'package:cube_painter/data/crop.dart';
import 'package:flutter/material.dart';

class Tile extends StatelessWidget {
  const Tile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => CustomPaint(
        painter: _Painter(
          cubeSide: getCubeSides(Crop.c)[1],
        ),
      );
}

class _Painter extends CustomPainter {
  final CubeSide cubeSide;

  const _Painter({
    required this.cubeSide,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(cubeSide.path,
        getGradientPaint(cubeSide.side, cubeSide.path, PaintingStyle.fill));

    canvas.drawPath(
        cubeSide.path,
        Paint()
          ..color = getColor(cubeSide.side)
          ..style = PaintingStyle.stroke);
  }

  @override
  bool shouldRepaint(_Painter oldDelegate) => false;
}

LinearGradient _getGradient(Side side) {
  switch (side) {
    case Side.t:
      return _gradientT;
    case Side.bl:
      return _gradientBL;
    case Side.br:
      return _gradientBR;
  }
}

Paint getGradientPaint(Side side, Path path, PaintingStyle style) {
  return Paint()
    ..shader = _getGradient(side).createShader(path.getBounds())
    ..style = style;
}

final _gradientT = LinearGradient(
  colors: [getColor(Side.br), getColor(Side.bl)],
  begin: Alignment.centerRight,
  end: Alignment.centerLeft,
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
