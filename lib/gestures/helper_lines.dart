import 'package:cube_painter/cubes/cube_sides.dart';
import 'package:cube_painter/gestures/brush.dart';
import 'package:cube_painter/hue.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/transform/position_to_unit.dart';
import 'package:cube_painter/transform/unit_to_screen.dart';
import 'package:flutter/material.dart';

const noWarn = out;

/// While brushing, this draws
/// three helper guide lines on the grid
/// from the drag start position,
/// to show the six directions
/// where the drag will end up.
class HelperLines extends StatelessWidget {
  const HelperLines({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final brushNotifier = getBrushNotifier(context, listen: true);

    final position = brushNotifier.helperLinesPosition;
    final offset = positionToUnitOffset(position);

    return brushNotifier.brush != Brush.addSlice
        ? _Lines(offset: offset)
        : Container();
  }
}

/// The implementation class for [HelperLines]
class _Lines extends StatelessWidget {
  const _Lines({Key? key, required this.offset}) : super(key: key);

  final Offset offset;

  @override
  Widget build(BuildContext context) {
    final offsets = getHexagonCornerOffsets();

    return UnitToScreen(
      child: Transform.translate(
        offset: offset,
        child: Transform.scale(
          // Deliberately big enough to cover whole screen.
          scale: 50,
          child: Stack(
            children: [
              _Line(offsets[0], offsets[0 + 3], color: Hue.bottomRight),
              _Line(offsets[1], offsets[1 + 3], color: Hue.top),
              _Line(offsets[2], offsets[2 + 3], color: Hue.bottomLeft),
            ],
          ),
        ),
      ),
    );
  }
}

/// Draws a line from a to b
class _Line extends StatelessWidget {
  const _Line(
    this.from,
    this.to, {
    Key? key,
    this.color = Colors.blue,
  }) : super(key: key);

  final Offset from;
  final Offset to;

  final Color color;

  @override
  Widget build(BuildContext context) =>
      CustomPaint(painter: _Painter(from, to, color));
}

/// The painter for [_Line]
class _Painter extends CustomPainter {
  const _Painter(this.from, this.to, this.color);

  final Offset from;
  final Offset to;

  final Color color;

  @override
  void paint(Canvas canvas, Size size) =>
      canvas.drawLine(from, to, Paint()..color = color);

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
