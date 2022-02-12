import 'package:cube_painter/buttons/hexagon_painter.dart';
import 'package:flutter/material.dart';

const unit = Offset(1, 1);

class Hexagon extends StatelessWidget {
  final Offset center;
  final double radius;

  final Color color;
  final bool repaint;

  const Hexagon({
    Key? key,
    required this.center,
    required this.radius,
    required this.color,
    this.repaint = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: center,
      child: Transform.scale(
        scale: radius,
        origin: unit,
        child: CustomPaint(
          painter: HexagonPainter(
            color: color,
            repaint: repaint,
          ),
        ),
      ),
    );
  }
}
