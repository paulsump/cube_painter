import 'package:flutter/material.dart';

class Line extends StatelessWidget {
  final Color color;

  final Offset from;
  final Offset to;

  const Line(
    this.from,
    this.to, {
    Key? key,
    this.color = Colors.blue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: LinePainter(from, to, color));
  }
}

class LinePainter extends CustomPainter {
  final Color color;

  final Offset from;
  final Offset to;

  const LinePainter(this.from, this.to, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(from, to, Paint()..color = color);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
