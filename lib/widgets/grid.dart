import 'package:cube_painter/shared/colors.dart';
import 'package:cube_painter/shared/enums.dart';
import 'package:cube_painter/shared/grid_transform.dart';
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

    final evenPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.black;

    final double N = Screen.width / getZoomScale(context);
    final int n = N.ceil();

    const y = -0.5;

    for (int i = 0; i < n; ++i) {
      canvas.drawLine(
        Offset(W * i, 0),
        Offset(W * i, y * n),
        paint,
      );
      if (i % 2 == 0) {
        canvas.drawLine(
          Offset(W * i, 0),
          Offset(W * i + W * (n - i), y * (n - i)),
          paint,
        );
        canvas.drawLine(
          Offset(0, y * i),
          Offset(W * (n - i), y * n),
          evenPaint,
        );
        canvas.drawLine(
          Offset(W * i, 0),
          Offset(0, y * i),
          paint,
        );
        // }else{
        canvas.drawLine(
          Offset(W * n, y * i),
          Offset(W * i, y * n),
          evenPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
