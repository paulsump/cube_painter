import 'package:cube_painter/buttons/calc_hexagon_points.dart';
import 'package:cube_painter/buttons/hexagon_painter.dart';
import 'package:flutter/material.dart';

class Hexagon extends StatelessWidget {
  final Offset center;
  final double radius;
  final Path path;

  // TODO MAke const by calling add poly in build? test profile
  Hexagon({
    Key? key,
    required this.center,
    required this.radius,
  })  : path = Path()..addPolygon(calcUnitHexagonPoints().toList(), true),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: center,
      child: Transform.scale(
        scale: radius,
        origin: const Offset(1, 1),
        child: CustomPaint(
          painter: HexagonPainter(
            context: context,
            path: path,
            alpha: 1,
          ),
        ),
      ),
    );
  }
}
