import 'dart:ui';

import 'package:cube_painter/cubes/tile.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/transform/pan_zoom.dart';
import 'package:cube_painter/transform/position_to_unit.dart';
import 'package:cube_painter/transform/screen.dart';
import 'package:flutter/material.dart';

const noWarn = [
  out,
  getScreen,
  lerpDouble,
  positionToUnitOffset,
  Tile,
];

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
