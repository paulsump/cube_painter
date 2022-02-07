import 'package:cube_painter/out.dart';
import 'package:cube_painter/rendering/colors.dart';
import 'package:cube_painter/rendering/side.dart';
import 'package:cube_painter/transform/grid_transform.dart';
import 'package:cube_painter/transform/screen_transform.dart';
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
    int n = _getN(Screen.height / H);
    const y = -H;

    final paintBL = Paint()
      ..style = PaintingStyle.stroke
      ..shader = LinearGradient(
        // colors: [getColor(Side.bl), getColor(Side.t)],
        colors: [Colors.red, Colors.green],
      ).createShader(Rect.fromPoints(
        Offset.zero,
        Offset(n * W, y * n),
      ));
    final paintT = Paint()
      ..style = PaintingStyle.stroke
      ..shader = LinearGradient(
        // colors: [getColor(Side.bl), getColor(Side.t)],
        colors: [Colors.red, Colors.green],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromPoints(
        Offset.zero,
        Offset(n * W, y * n),
      ));
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..shader = LinearGradient(
        colors: [getColor(Side.t), getColor(Side.bl)],
      ).createShader(Rect.fromPoints(
        Offset.zero,
        Offset(n * W / 2, y * n),
      ));
    //   ..shader = ui.Gradient.linear(
    //       Offset.zero, Offset(n*W/2,y*n), [
    //     getColor(Side.br),
    //     getColor(Side.bl),
    //   ]);

    // left
    if (true) {
      for (int i = 2; i < n; i += 2) {
        // lower
        canvas.drawLine(
          Offset(W * i, 0),
          Offset(0, y * i),
          paintT,
        );
        // upper
        canvas.drawLine(
          Offset(0, y * i),
          Offset(W * (n - i), y * n),
          paintT,
        );
      }
    }
    // n = _getN(Screen.width / W);

    if (false) {
      for (int i = 0; i < n; ++i) {
        // vertical
        canvas.drawLine(
          Offset(W * i, 0),
          Offset(W * i, y * n),
          paintT,
        );
      }
    }
    // right
    if (true) {
      for (int i = 0; i < n; i += 2) {
        // lower
        canvas.drawLine(
          Offset(W * i, 0),
          Offset(W * n, y * (n - i)),
          paintT,
        );

        // upper
        canvas.drawLine(
          Offset(W * n, y * i),
          Offset(W * i, y * n),
          paintT,
        );
      }
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
