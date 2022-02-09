import 'package:cube_painter/rendering/colors.dart';
import 'package:cube_painter/rendering/side.dart';
import 'package:cube_painter/transform/screen_transform.dart';
import 'package:flutter/material.dart';

class HexagonPainter extends CustomPainter {
  final BuildContext context;

  final Path path;
  final double alpha;
  final Color? color;

  const HexagonPainter({
    required this.context,
    required this.path,
    required this.alpha,
    required this.color,
  });

  Color get _color => color ?? getColor(Side.t).withOpacity(alpha);

  @override
  void paint(Canvas canvas, Size size) {
    clip(canvas);

    canvas.drawPath(
        path,
        Paint()
          ..color = _color
          ..style = PaintingStyle.fill);

    canvas.drawPath(
        path,
        Paint()
          ..color = getColor(Side.bl)
          ..style = PaintingStyle.stroke);
  }

  @override
  bool shouldRepaint(HexagonPainter oldDelegate) => false;
}
