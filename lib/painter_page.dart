import 'dart:ui';

import 'package:cube_painter/brush/brush.dart';
import 'package:cube_painter/brush_menu.dart';
import 'package:cube_painter/cubes/cubes.dart';
import 'package:cube_painter/cubes/static_cube.dart';
import 'package:cube_painter/cubes/tiles.dart';
import 'package:cube_painter/data/crop.dart';
import 'package:cube_painter/data/cube_group.dart';
import 'package:cube_painter/file_menu.dart';
import 'package:cube_painter/gesture_mode.dart';
import 'package:cube_painter/open_menu_button.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/transform/pan_zoom.dart';
import 'package:cube_painter/transform/position_to_unit.dart';
import 'package:cube_painter/transform/screen.dart';
import 'package:cube_painter/transform/unit_to_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// prevent 'organise imports' from removing imports
/// when temporarily commenting out.
const noWarn = [
  out,
  getScreen,
  PanZoomer,
  lerpDouble,
  positionToUnitOffset,
  Tiles,
  StaticCubes,
  Crop.c,
  Provider,
];

class PainterPage extends StatefulWidget {
  const PainterPage({Key? key}) : super(key: key);

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
    final cubeGroup = getCubeGroup(context, listen: true);

    const double barHeight = 87;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: barHeight,
        // backgroundColor: backgroundColor,
        backgroundColor: Colors.transparent,
        leading: const OpenMenuButton(endDrawer: false),
        actions: const <Widget>[
          OpenMenuButton(endDrawer: true),
        ],
      ),
      drawer: const FileMenu(),
      endDrawer: BrushMenu(cubes: _cubes),
      body: SafeArea(
        child: Stack(children: [
          UnitToScreen(
            child: Stack(
              children: [
                const Tiles(),
                if (cubeGroup.cubeInfos.isNotEmpty)
                  StaticCubes(cubeGroup: cubeGroup),
                ..._cubes.animCubes,
              ],
            ),
          ),
          GestureMode.panZoom == getGestureMode(context, listen: true)
              ? const PanZoomer()
              : Brush(adoptCubes: _cubes.adopt),
        ]),
      ),
    );
  }
}
