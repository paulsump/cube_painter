import 'dart:collection';

import 'package:cube_painter/cubes/cube_sides.dart';
import 'package:cube_painter/gestures/brush.dart';
import 'package:cube_painter/persisted/animator.dart';
import 'package:cube_painter/persisted/painting_bank.dart';
import 'package:cube_painter/transform/position_to_unit.dart';
import 'package:cube_painter/transform/unit_to_screen.dart';
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
    final offsets = getHexagonCornerOffsets();

    final paintingBank = getPaintingBank(context, listen: true);

    return CubeAnimState.brushing == paintingBank.cubeAnimState
        ? _Lines(offsets: offsets)
        : Container();
  }
}

class _Lines extends StatelessWidget {
  final UnmodifiableListView<Offset> offsets;

  const _Lines({
    Key? key,
    required this.offsets,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final position = getBrushStartPosition(context, listen: true);

    final startOffset = positionToUnitOffset(position);

    return UnitToScreen(
      child: Transform.translate(
        offset: startOffset,
        child: Transform.scale(
          scale: 10,
          child: Stack(
            children: [
              for (int i = 0; i < 3; ++i) _Line(offsets[i], offsets[i + 3]),
            ],
          ),
        ),
      ),
    );
  }
}

class _Line extends StatelessWidget {
  final Color color;

  final Offset from;
  final Offset to;

  const _Line(
    this.from,
    this.to, {
    Key? key,
        this.color = Colors.blue,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      CustomPaint(painter: _Painter(from, to, color));
}

/// the painter for [_Line]
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
