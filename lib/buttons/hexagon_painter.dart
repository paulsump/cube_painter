import 'package:cube_painter/buttons/calc_hexagon_points.dart';
import 'package:cube_painter/colors.dart';
import 'package:cube_painter/cubes/side.dart';
import 'package:flutter/material.dart';

class HexagonPainter extends CustomPainter {
  final BuildContext context;

  final double alpha;

  final Color? color;
  final Color? borderColor;

  final bool repaint;

  const HexagonPainter({
    required this.context,
    required this.alpha,
    this.color,
    this.borderColor,
    this.repaint = false,
  });

  Color get _color => color ?? buttonColor.withOpacity(alpha);

  Color get _borderColor => borderColor ?? getColor(Side.bl);

  @override
  void paint(Canvas canvas, Size size) {
    // clip(canvas, context);
    final path = Path()..addPolygon(calcHexagonPoints(), true);

    canvas.drawPath(
        path,
        Paint()
          ..color = _color
          ..style = PaintingStyle.fill);

    canvas.drawPath(
        path,
        Paint()
          ..color = _borderColor
          ..style = PaintingStyle.stroke);
  }

  @override
  bool shouldRepaint(HexagonPainter oldDelegate) => repaint;
}
