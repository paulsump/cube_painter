import 'package:cube_painter/shared/colors.dart';
import 'package:cube_painter/shared/enums.dart';
import 'package:cube_painter/shared/grid_point.dart';
import 'package:cube_painter/shared/grid_transform.dart';
import 'package:cube_painter/shared/out.dart';
import 'package:cube_painter/shared/screen_transform.dart';
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
    final paint = Paint()
      ..style = PaintingStyle.stroke
      // TODO Fix
      ..shader = LinearGradient(
        colors: [getColor(Vert.br), getColor(Vert.bl)],
        // begin: Alignment.topCenter,
        // end: Alignment.bottomCenter,
      ).createShader(
        Screen.rect,
        // Rect.fromPoints(topLeft, to),
      );

    final double N = Screen.width/getZoomScale(context);
    final int n = N.ceil();

    for (int i = 0; i < n; ++i) {
      canvas.drawLine(
        Offset(gridStep.dx * i, 0),
        Offset(gridStep.dx * i, gridStep.dy * n),
        paint,
      );
      if (i % 2 == 0) {
        canvas.drawLine(
          Offset(gridStep.dx * i, 0),
          Offset(
              gridStep.dx * i + gridStep.dx * (n - i), gridStep.dy * (n - i)),
          paint,
        );
        canvas.drawLine(
          Offset(0, gridStep.dy * i),
          Offset(gridStep.dx * (n - i), gridStep.dy * n),
          paint,
        );
        canvas.drawLine(
          Offset(gridStep.dx * i, 0),
          Offset(0, gridStep.dy * i),
          paint,
        );
      }else{
        canvas.drawLine(
          Offset(gridStep.dx*n, gridStep.dy * i),
          Offset(gridStep.dx * i, gridStep.dy * n),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
