import 'package:cube_painter/shared/colors.dart';
import 'package:cube_painter/shared/enums.dart';
import 'package:cube_painter/shared/grid_point.dart';
import 'package:cube_painter/shared/grid_transform.dart';
import 'package:cube_painter/shared/out.dart';
import 'package:cube_painter/shared/screen.dart';
import 'package:flutter/material.dart';

class Grid extends StatelessWidget {
  const Grid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: GridPainter(
        context: context,
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  final BuildContext context;

  GridPainter({required this.context});

  @override
  void paint(Canvas canvas, Size size) {
    // clip(canvas);

    final Offset gridStep = toOffset(const GridPoint(1, 1));
    // out(gridStep);

    // final int n = Screen.width ~/ gridStep.dx;
    // out(n);
    const int n = 10;
    for (int i = 0; i < n; ++i) {
      canvas.drawLine(
        Offset(gridStep.dx * i, 0),
        Offset(gridStep.dx * i, gridStep.dy*n),
        Paint()
          ..style = PaintingStyle.stroke
          ..shader = LinearGradient(
            colors: [getColor(Vert.t), getColor(Vert.bl)],
          ).createShader(
            Screen.rect,
            // Rect.fromPoints(topLeft, to),
          ),
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
