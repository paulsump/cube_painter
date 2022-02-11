import 'package:cube_painter/colors.dart';
import 'package:cube_painter/cubes/side.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/transform/grid_transform.dart';
import 'package:flutter/material.dart';

const noWarn = out;

class Grid extends StatelessWidget {
  final double height;

  final double scale;

  const Grid({
    Key? key,
    required this.height,
    required this.scale,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => CustomPaint(
          painter: GridPainter(
        height: height,
        scale: scale,
      ));
}

class GridPainter extends CustomPainter {
  final double height;

  final double scale;

  const GridPainter({
    required this.height,
    required this.scale,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // TODO take panOffset off, but don't just move grid - it might move off the correct positions.
    int n = _getN(height / H / scale);
    const y = -H;

    final rect = Rect.fromPoints(
      Offset.zero,
      Offset(n * W, y * n),
    );

    final paintBR = Paint()
      ..style = PaintingStyle.stroke
      ..shader = _gradientBR.createShader(rect);

    final paintBL = Paint()
      ..style = PaintingStyle.stroke
      ..shader = _gradientBL.createShader(rect);

    // left
    for (int i = 2; i < n; i += 2) {
      // lower
      canvas.drawLine(
        Offset(W * i, 0),
        Offset(0, y * i),
        paintBL,
      );
      // upper
      canvas.drawLine(
        Offset(0, y * i),
        Offset(W * (n - i), y * n),
        paintBR,
      );
    }
    // n = _getN(Screen.width / W/scale);

    // right
    for (int i = 0; i < n; i += 2) {
      // lower
      canvas.drawLine(
        Offset(W * i, 0),
        Offset(W * n, y * (n - i)),
        paintBR,
      );

      // upper
      canvas.drawLine(
        Offset(W * n, y * i),
        Offset(W * i, y * n),
        paintBL,
      );
    }
  }

  int _getN(double N) {
    int n = N.round();
    return n + n % 2;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

final _gradientBR = LinearGradient(
  colors: [getColor(Side.t), getColor(Side.br)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

final _gradientBL = LinearGradient(
  colors: [getColor(Side.bl), getColor(Side.t)],
  begin: Alignment.bottomLeft,
  end: Alignment.topRight,
);
