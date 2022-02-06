import 'package:cube_painter/shared/grid_transform.dart';
import 'package:cube_painter/shared/out.dart';
import 'package:cube_painter/shared/screen_transform.dart';
import 'package:flutter/material.dart';

const noWarn = out;

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
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.black;

    const y = -H;
    int n = _getN(Screen.height / H);

    // left
    for (int i = 2; i < n; i += 2) {
      // lower
      canvas.drawLine(
        Offset(W * i, 0),
        Offset(0, y * i),
        paint,
      );
      // upper
      canvas.drawLine(
        Offset(0, y * i),
        Offset(W * (n - i), y * n),
        paint,
      );
    }

    // n = _getN(Screen.width / W);

    for (int i = 0; i < n; ++i) {
      // vertical
      canvas.drawLine(
        Offset(W * i, 0),
        Offset(W * i, y * n),
        paint,
      );
    }

    // right
    for (int i = 0; i < n; i += 2) {
      // lower
      canvas.drawLine(
        Offset(W * i, 0),
        Offset(W * n, y * (n - i)),
        paint,
      );

      // upper
      canvas.drawLine(
        Offset(W * n, y * i),
        Offset(W * i, y * n),
        paint,
      );
    }
  }

  int _getN(double factor) {
    double N = factor / getZoomScale(context);

    int n = N.round();
    return n + n % 2;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
