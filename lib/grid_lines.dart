import 'package:flutter/material.dart';

/// While brushing, this draws
/// three helper guide lines on the grid
/// from the drag start position,
/// to show the six directions
/// where the drag will end up.
/// TODO rename to GridGuideLines
class GridLines extends StatelessWidget {
  const GridLines({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

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
  Widget build(BuildContext context) =>
      CustomPaint(painter: _Painter(from, to, color));
}

/// the painter for [Line]
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
