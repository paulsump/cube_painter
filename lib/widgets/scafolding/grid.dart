import 'package:cube_painter/out.dart';
import 'package:cube_painter/rendering/colors.dart';
import 'package:cube_painter/rendering/side.dart';
import 'package:cube_painter/transform/grid_transform.dart';
import 'package:cube_painter/transform/screen_transform.dart';
import 'package:flutter/material.dart';

const noWarn = out;

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

final paintBR = Paint()
  ..style = PaintingStyle.stroke
  ..color = getColor(Side.br);

final paintBL = Paint()
  ..style = PaintingStyle.stroke
  ..color = getColor(Side.bl);

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
    int n = _getN(Screen.height / H);
    const y = -H;

    // final rect = Rect.fromPoints(
    //   Offset.zero,
    //   Offset(n * W, y * n),
    // );

    // final paintBR = Paint()
    //   ..style = PaintingStyle.stroke
    //   ..shader = _gradientBR.createShader(rect);
    //
    // final paintBL = Paint()
    //   ..style = PaintingStyle.stroke
    //   ..shader = _gradientBL.createShader(rect);

    const int step = 2;
    // left
    for (int i = 2; i < n; i += 2 * step) {
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
    // n = _getN(Screen.width / W);

    // right
    for (int i = 0; i < n; i += 2 * step) {
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

  int _getN(double factor) {
    double N = factor / getZoomScale(context);

    int n = N.round();
    return n + n % 2;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
