import 'package:cube_painter/colors.dart';
import 'package:cube_painter/cubes/cube_sides.dart';
import 'package:cube_painter/cubes/side.dart';
import 'package:flutter/material.dart';

class HexagonPainter extends CustomPainter {
  final Color color;

  final bool repaint;

  const HexagonPainter({required this.color, required this.repaint});

  @override
  void paint(Canvas canvas, Size size) {
    // clip(canvas, context);
    final path = Path()..addPolygon(calcHexagonOffsets(), true);

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
  bool shouldRepaint(HexagonPainter oldDelegate) => repaint;
}
