import 'package:cube_painter/colors.dart';
import 'package:cube_painter/cubes/cube_sides.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/transform/pan_zoom.dart';
import 'package:cube_painter/transform/position_to_unit.dart';
import 'package:cube_painter/transform/screen.dart';
import 'package:flutter/material.dart';

const noWarn = [out, green];

class Tile extends StatelessWidget {
  final Offset bottom;

  final double scale;

  const Tile({
    Key? key,
    required this.bottom,
    required this.scale,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: bottom,
      child: Transform.scale(
        scale: scale,
        child: const _UnitTile(),
      ),
    );
  }
}

class _UnitTile extends StatelessWidget {
  const _UnitTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const CustomPaint(painter: _Painter());
}

class _Painter extends CustomPainter {
  const _Painter();

  @override
  void paint(Canvas canvas, Size size) =>
      canvas.drawPath(Path()..addPolygon(topSide, true), _paintCache);

  @override
  bool shouldRepaint(_Painter oldDelegate) => false;
}

final Paint _paintCache = Paint()
  ..shader = const LinearGradient(
    // from diamonds pic
    // colors: [Color(0xff2e8c86), Color(0xff2c778f)],
    // colors: [ blue,green],
    // colors:colors,
    colors: [Color(0xff5ebaa9), Color(0xff3faa98)],
    // quilt
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    //waves
    // begin: Alignment.topCenter,
    // end: Alignment.bottomCenter,
  ).createShader(const Rect.fromLTRB(-0.9, -1.0, 0.9, 0.0))
  ..style = PaintingStyle.fill;

// const double dt = 0.1;
// const double t = 0.5;
// final colors = [getTweenBtoGColor(t - dt), getTweenBtoGColor(t + dt)];

// Paint _getGradientPaint(double t, Path path, PaintingStyle style) {
//   return Paint()
//     ..shader = _getGradient(t).createShader(path.getBounds())
//     ..style = style;
// }
//
// LinearGradient _getGradient(double t) => LinearGradient(
//       // colors: [getTweenBLtoTColor(t - dt), getTweenBLtoTColor(t + dt)],
//       colors: [getTweenBtoGColor(t - dt), getTweenBtoGColor(t + dt)],
//       begin: Alignment.topCenter,
//       end: Alignment.bottomCenter,
//     );

class Tiles {
  final List<Tile> tiles = [];
  double previousScreenHeight = 0;

  late void Function(VoidCallback fn) setState;
  late BuildContext context;

  void init({
    required void Function(VoidCallback fn) setState_,
    required BuildContext context_,
  }) {
    setState = setState_;
    context = context_;
  }

  void rebuildIfReorient({
    required double height,
  }) {
    if (height != previousScreenHeight) {
      rebuild();
      previousScreenHeight = height;
    }
  }

  void rebuild() {
    tiles.clear();

    final screen = getScreen(context, listen: false);
    final double zoomScale = getZoomScale(context);

    final Offset panOffset = getPanOffset(context, listen: false) / zoomScale;
    final int tileScale = zoomScale > 50
        ? 1
        : zoomScale > 30
            ? 2
            : 3;

    final double w = tileScale * W;
    double panX = panOffset.dx;
    panX -= panX % w;

    if ((panX / w) % 2 != 0) {
      panX -= w;
    }

    final double h = tileScale * H;
    double panY = panOffset.dy;
    panY -= panY % h;

    if ((panY / h) % 2 != 0) {
      panY -= h;
    }

    final Offset center = screen.center / zoomScale;

    double centerX = center.dx;
    centerX -= centerX % w;

    if ((centerX / w) % 2 != 0) {
      centerX -= w;
    }

    double centerY = center.dy;
    centerY -= centerY % h;

    if ((centerY / h) % 2 != 0) {
      centerY -= h;
    }

    final int nx = screen.width ~/ zoomScale;
    final int ny = screen.height ~/ zoomScale;

    int padX = 6;
    int padY = 5;

    if (zoomScale < 44) {
      padX += 2 * tileScale;
      padY += 1 * tileScale;
    }

    for (int x = -padX; x < nx + padX; x += tileScale) {
      for (int y = -padY; y < ny + padY; y += tileScale) {
        final double h = x % (2 * tileScale) == 0 ? 0 : tileScale * H;

        double Y = h + y.toDouble();
        double X = W * x.toDouble();

        X -= panX;
        Y -= panY;

        X -= centerX;
        Y -= centerY;

        tiles.add(Tile(
          bottom: Offset(X, Y),
          scale: tileScale.toDouble(),
        ));
      }
    }
    setState(() {});
  }
}
