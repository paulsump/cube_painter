import 'dart:ui';

import 'package:cube_painter/brush/brush.dart';
import 'package:cube_painter/buttons/hexagon_button.dart';
import 'package:cube_painter/buttons/open_menu_button.dart';
import 'package:cube_painter/colors.dart';
import 'package:cube_painter/cubes/cubes.dart';
import 'package:cube_painter/cubes/static_cube.dart';
import 'package:cube_painter/cubes/tiles.dart';
import 'package:cube_painter/data/crop.dart';
import 'package:cube_painter/data/cube_group.dart';
import 'package:cube_painter/gesture_mode.dart';
import 'package:cube_painter/menu/brush_menu.dart';
import 'package:cube_painter/menu/file_menu.dart';
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
    final cubeGroupNotifier = getCubeGroupNotifier(context, listen: true);

    final bool canUndo = _cubes.undoer.canUndo;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      drawer: const FileMenu(),
      endDrawer: BrushMenu(cubes: _cubes),
      body: SafeArea(
        child: Stack(children: [
          UnitToScreen(
            child: Stack(
              children: [
                const Tiles(),
                if (cubeGroupNotifier.hasCubes)
                  StaticCubes(cubeGroup: cubeGroupNotifier.cubeGroup),
                ..._cubes.animCubes,
              ],
            ),
          ),
          GestureMode.panZoom == getGestureMode(context, listen: true)
              ? const PanZoomer()
              : Brush(adoptCubes: _cubes.adopt),
          const OpenMenuButton(endDrawer: false),
          Transform.translate(
            offset: Offset(width - 60, 0),
            child: const OpenMenuButton(endDrawer: true),
          ),
          Transform.translate(
            offset: Offset(width - 60, 55),
            child: HexagonButton(
              height: 55,
              child: Icon(
                Icons.undo_sharp,
                size: iconSize,
                color: canUndo ? enabledIconColor : disabledIconColor,
              ),
              onPressed: canUndo ? _cubes.undoer.undo : null,
              tip: 'Undo the last add or delete operation.',
            ),
          ),
        ]),
      ),
    );
  }
}
