import 'dart:ui';

import 'package:cube_painter/brush/brush.dart';
import 'package:cube_painter/buttons/cube_button.dart';
import 'package:cube_painter/buttons/hexagon_elevated_button.dart';
import 'package:cube_painter/buttons/open_file_menu_button.dart';
import 'package:cube_painter/buttons/open_slice_menu_button.dart';
import 'package:cube_painter/colors.dart';
import 'package:cube_painter/cubes/cubes.dart';
import 'package:cube_painter/cubes/static_cube.dart';
import 'package:cube_painter/cubes/tiles.dart';
import 'package:cube_painter/data/cube_group.dart';
import 'package:cube_painter/data/slice.dart';
import 'package:cube_painter/downloaded_icons.dart';
import 'package:cube_painter/gesture_mode.dart';
import 'package:cube_painter/menu/file_menu.dart';
import 'package:cube_painter/menu/slice_mode_menu.dart';
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
  Slice.whole,
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

    final gestureMode = getGestureMode(context, listen: true);
    final double width = MediaQuery.of(context).size.width;

    final bool canUndo = _cubes.undoer.canUndo;
    final bool canRedo = _cubes.undoer.canRedo;

    return Scaffold(
      drawer: const FileMenu(),
      endDrawer: const SliceModeMenu(),
      drawerEnableOpenDragGesture: false,
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
          GestureMode.panZoom == gestureMode
              ? PanZoomer()
              : Brush(adoptCubes: _cubes.adopt),
          const OpenFileMenuButton(),
          Transform.translate(
            offset: Offset(width - 66 * 4 + 18, 0),
            child: SizedBox(
              height: 66,
              child: CubeButton(
                radioOn: GestureMode.add == gestureMode,
                icon: DownloadedIcons.plusOutline,
                iconSize: downloadedIconSize,
                onPressed: () {
                  setGestureMode(GestureMode.add, context);
                  setSliceMode(Slice.whole, context);
                },
                tip:
                    'Tap or drag on the canvas to add a row of cubes. You can change the direction while you drag.',
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(width - 66 * 3 + 11.5, 0),
            child: CubeButton(
              radioOn: GestureMode.erase == gestureMode,
              icon: DownloadedIcons.cancelOutline,
              iconSize: downloadedIconSize,
              onPressed: () {
                setGestureMode(GestureMode.erase, context);
              },
              tip:
                  'Tap on a cube to delete it.  You can change the position while you have your finger down.',
            ),
          ),
          Transform.translate(
            offset: Offset(width - 66 * 2 + 7, 1),
            child: HexagonElevatedButton(
              radioOn: GestureMode.panZoom == gestureMode,
              child: Icon(
                Icons.zoom_in_sharp,
                size: iconSize * 1.2,
                color: enabledIconColor,
              ),
              onPressed: () => setGestureMode(GestureMode.panZoom, context),
              tip: 'Pinch to zoom, drag to move around.',
            ),
          ),
          Transform.translate(
            offset: Offset(width - 66 - 1.5, 0),
            child: const OpenSliceMenuButton(),
          ),
          if (canUndo || canRedo)
            Transform.translate(
              offset: Offset(width - 66 + 1, 66 * 1 + 3),
              child: HexagonElevatedButton(
                child: Icon(
                  Icons.undo_sharp,
                  size: iconSize,
                  color: canUndo ? enabledIconColor : disabledIconColor,
                ),
                onPressed: canUndo ? _cubes.undoer.undo : null,
                tip: 'Undo the last add or delete operation.',
              ),
            ),
          if (canRedo)
            Transform.translate(
              offset: Offset(width - 66 + 1, 66 * 2 + 3),
              child: HexagonElevatedButton(
                tip: 'Redo the last add or delete operation that was undone.',
                child: Icon(
                  Icons.redo_sharp,
                  color: canRedo ? enabledIconColor : disabledIconColor,
                  size: iconSize,
                ),
                onPressed: canRedo ? _cubes.undoer.redo : null,
              ),
            ),
        ]),
      ),
    );
  }
}
