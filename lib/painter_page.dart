import 'dart:ui';

import 'package:cube_painter/brush/brush.dart';
import 'package:cube_painter/buttons/hexagon_button_bar.dart';
import 'package:cube_painter/colors.dart';
import 'package:cube_painter/cubes/cubes.dart';
import 'package:cube_painter/cubes/tiles.dart';
import 'package:cube_painter/gesture_mode.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/transform/pan_zoom.dart';
import 'package:cube_painter/transform/position_to_unit.dart';
import 'package:cube_painter/transform/screen.dart';
import 'package:cube_painter/transform/unit_to_screen.dart';
import 'package:flutter/material.dart';

/// prevent 'organise imports' from removing imports
/// when temporarily commenting out.
const noWarn = [
  out,
  getScreen,
  PanZoomer,
  lerpDouble,
  positionToUnitOffset,
];

class PainterPage extends StatefulWidget {
  const PainterPage({Key? key}) : super(key: key);

  @override
  State<PainterPage> createState() => _PainterPageState();
}

class _PainterPageState extends State<PainterPage> {
  final _cubes = Cubes();

  final _tiles = Tiles();
// final _tips = Tips();

  @override
  void initState() {
    _cubes.init(setState_: setState, context_: context);

    _tiles.init(setState_: setState, context_: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screen = getScreen(context, listen: true);

    _tiles.rebuildIfReorient(height: screen.height);
    const double buttonsBarHeight = 80;

    return Column(
      children: [
        SizedBox(
          height: screen.height - buttonsBarHeight,
          child: Stack(
            children: [
              UnitToScreen(
                child: Stack(
                  children: [
                    ..._tiles.tiles,
                    ..._cubes.simpleCubes,
                    ..._cubes.animCubes,
                  ],
                ),
              ),
              Brush(adoptCubes: _cubes.adopt),
              if (GestureMode.panZoom == getGestureMode(context, listen: true))
                PanZoomer(
                  onPanZoomUpdate: _tiles.rebuild,
                  onPanZoomEnd: _tiles.rebuild,
                ),
              // Line(screen.center,screen.center + Offset(screen.width / 4, screen.height / 4)),
            ],
          ),
        ),
        Container(
          height: buttonsBarHeight,
          color: backgroundColor,
          child: HexagonButtonBar(
            undoer: _cubes.undoer,
            saveToClipboard: _cubes.saveToClipboard,
            showTip: _showTip,
            hideTip: _hideTip,
            height: buttonsBarHeight,
          ),
        ),
      ],
    );
  }

  void _showTip(String message) {
    out(message);
    //TODO Text at bottom
    //TODO Demo wants to use these strings, but i'll refactor if i get to that
    // demo points to button, presses it and shows tip
    // extrude add two triangle lines
    // delete one, undo redo one
    // crop tto make triangle
    // zoom in , out
    // next file , next file , to new one.
  }

  void _hideTip() {}
}
