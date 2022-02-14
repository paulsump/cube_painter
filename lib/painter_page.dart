import 'dart:ui';

import 'package:cube_painter/brush/brush.dart';
import 'package:cube_painter/buttons/hexagon_button_bar.dart';
import 'package:cube_painter/cubes/cubes.dart';
import 'package:cube_painter/cubes/simple_tile.dart';
import 'package:cube_painter/gesture_mode.dart';
import 'package:cube_painter/line.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/transform/pan_zoom.dart';
import 'package:cube_painter/transform/position_to_unit.dart';
import 'package:cube_painter/transform/screen.dart';
import 'package:cube_painter/transform/unit_to_screen.dart';
import 'package:flutter/material.dart';

const noWarn = [
  out,
  getScreen,
  Line,
  PanZoomer,
  lerpDouble,
  positionToUnitOffset,
  SimpleTile,
];

class PainterPage extends StatefulWidget {
  const PainterPage({
    Key? key,
  }) : super(key: key);

  @override
  State<PainterPage> createState() => _PainterPageState();
}

class _PainterPageState extends State<PainterPage> {
  final _cubes = Cubes();

  final List<SimpleTile> _tiles = [];
  double previousScreenHeight = 0;

  @override
  void initState() {
    _cubes.init(setState_: setState, context_: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screen = getScreen(context, listen: true);

    if (screen.height != previousScreenHeight) {
      _rebuildTiles();
      previousScreenHeight = screen.height;
    }

    const double buttonsBarHeight = 100;

    return Column(
      children: [
        SizedBox(
          height: screen.height - buttonsBarHeight,
          child: Stack(
            children: [
              UnitToScreen(
                child: Stack(
                  children: [
                    ..._tiles,
                    ..._cubes.simpleCubes,
                    ..._cubes.animCubes,
                  ],
                ),
              ),
              Brush(adoptCubes: _cubes.adoptCubes),
              if (GestureMode.panZoom == getGestureMode(context, listen: true))
                PanZoomer(
                  onPanZoomUpdate: _rebuildTiles,
                  onPanZoomEnd: _rebuildTiles,
                ),
              // Line(screen.center,screen.center + Offset(screen.width / 4, screen.height / 4)),
            ],
          ),
        ),
        SizedBox(
          height: buttonsBarHeight,
          child: HexagonButtonBar(
            undoer: _cubes.undoer,
            saveToClipboard: _cubes.saveToClipboard,
          ),
        ),
      ],
    );
  }

  void _rebuildTiles() {
    _tiles.clear();

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

        _tiles.add(SimpleTile(
          bottom: Offset(X, Y),
          scale: tileScale.toDouble(),
        ));
      }
    }
    setState(() {});
  }
}
