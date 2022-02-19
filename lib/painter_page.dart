import 'dart:ui';

import 'package:cube_painter/brush/brush.dart';
import 'package:cube_painter/buttons/hexagon_button_bar.dart';
import 'package:cube_painter/cubes/cubes.dart';
import 'package:cube_painter/cubes/static_cube.dart';
import 'package:cube_painter/cubes/tiles.dart';
import 'package:cube_painter/data/cube_group.dart';
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
  Tiles,
  HexagonButtonBar,
  getCubeInfos,
  StaticCubes,
];

class PainterPage extends StatefulWidget {
  GlobalKey<ScaffoldState> scaffoldState;

  PainterPage({Key? key, required this.scaffoldState}) : super(key: key);

  @override
  State<PainterPage> createState() => _PainterPageState();
}

class _PainterPageState extends State<PainterPage> {
  final _cubes = Cubes();

  @override
  void initState() {
    _cubes.init(setState_: setState, context_: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screen = getScreen(context, listen: true);

    final cubeInfos = getCubeInfos(context, listen: true);
    return Stack(children: [
      UnitToScreen(
        child: Stack(
          children: [
            const Tiles(),
            StaticCubes(cubeInfos: cubeInfos),
            ..._cubes.animCubes,
          ],
        ),
      ),
      GestureMode.panZoom == getGestureMode(context, listen: true)
          ? const PanZoomer()
          : Brush(adoptCubes: _cubes.adopt),
      HexagonButtonBar(
          undoer: _cubes.undoer,
          saveToClipboard: _cubes.saveToClipboard,
          screen: screen,
          scaffoldState: widget.scaffoldState),
    ]);
  }
}
