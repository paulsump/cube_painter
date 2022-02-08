import 'package:cube_painter/buttons/calc_hexagon_points.dart';
import 'package:cube_painter/buttons/hexagon_painter.dart';
import 'package:flutter/material.dart';

class Hexagon extends StatelessWidget {
  final Offset center;
  final double radius;
  final Path path;

  // TODO MAke const by callin add poly in build? test profile
  Hexagon({
    Key? key,
    required this.center,
    required this.radius,
  })  : path = Path()..addPolygon(calcHexagonPoints(center, radius), true),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: HexagonPainter(
        context: context,
        path: path,
        alpha: 1,
      ),
    );
  }
}
