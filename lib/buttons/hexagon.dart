import 'package:cube_painter/colors.dart';
import 'package:cube_painter/cubes/cube_sides.dart';
import 'package:flutter/material.dart';

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
        scale: radius * 0.8,
        origin: unit,
        child: CustomPaint(
          painter: _Painter(
            color: color,
            repaint: repaint,
          ),
        ),
      ),
    );
  }
}

class _Painter extends CustomPainter {
  final Color color;

  final bool repaint;

  const _Painter({required this.color, required this.repaint});

  @override
  void paint(Canvas canvas, Size size) {
    // clip(canvas, context);
    final path = Path()..addPolygon(getHexagonCornerOffsets(), true);

    canvas.drawPath(
        path,
        Paint()
          ..color = color
          ..style = PaintingStyle.fill);

    canvas.drawPath(
        path,
        Paint()
          ..color = getColor(Side.bl)
          ..style = PaintingStyle.stroke);
  }

  @override
  bool shouldRepaint(_Painter oldDelegate) => repaint;
}
