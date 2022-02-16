import 'dart:ui';

import 'package:cube_painter/brush/brush.dart';
import 'package:cube_painter/buttons/hexagon_button_bar.dart';
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

    return Stack(children: [
      UnitToScreen(
        child: Stack(
          children: [
            ..._tiles.tiles,
            ..._cubes.simpleCubes,
            ..._cubes.animCubes,
          ],
        ),
      ),
      GestureMode.panZoom == getGestureMode(context, listen: true)
          ? PanZoomer(
              onPanZoomUpdate: _tiles.rebuild,
              onPanZoomEnd: _tiles.rebuild,
            )
          : Brush(adoptCubes: _cubes.adopt),
      HexagonButtonBar(
        undoer: _cubes.undoer,
        saveToClipboard: _cubes.saveToClipboard,
        screen: screen,
      ),
    ]);
  }
}
