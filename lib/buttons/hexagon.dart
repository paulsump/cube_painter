import 'package:cube_painter/buttons/hexagon_painter.dart';
import 'package:flutter/material.dart';

class Hexagon extends StatelessWidget {
  final Offset center;
  final double radius;

  const Hexagon({
    Key? key,
    required this.center,
    required this.radius,
  }) : super(key: key);

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
            alpha: 1,
          ),
        ),
      ),
    );
  }
}
