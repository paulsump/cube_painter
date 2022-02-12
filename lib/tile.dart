import 'package:flutter/material.dart';

/// grid is made up of these line widgets a bit like a wire mesh
class Tile extends StatelessWidget {
  final Color color;

  final Offset from;
  final Offset to;

  const Tile(
    this.from,
    this.to, {
    Key? key,
    this.color = Colors.blue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      CustomPaint(painter: _Painter(from, to, color));
}

class _Painter extends CustomPainter {
  final Color color;

  final Offset from;
  final Offset to;

  const _Painter(this.from, this.to, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(from, to, Paint()..color = color);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
