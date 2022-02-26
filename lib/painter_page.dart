import 'package:cube_painter/brush/brush.dart';
import 'package:cube_painter/buttons/page_buttons.dart';
import 'package:cube_painter/cubes/cubes.dart';
import 'package:cube_painter/cubes/static_cube.dart';
import 'package:cube_painter/cubes/tiles.dart';
import 'package:cube_painter/data/sketch.dart';
import 'package:cube_painter/data/slice.dart';
import 'package:cube_painter/gesture_mode.dart';
import 'package:cube_painter/menu/file_menu.dart';
import 'package:cube_painter/menu/slice_mode_menu.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/transform/pan_zoom.dart';
import 'package:cube_painter/transform/unit_to_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// prevent 'organise imports' from removing imports
/// when temporarily commenting out.
const noWarn = [
  out,
  PanZoomer,
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
    final sketchNotifier = getSketchBank(context, listen: true);

    final gestureMode = getGestureMode(context, listen: true);

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
                if (sketchNotifier.hasCubes)
                  StaticCubes(sketch: sketchNotifier.sketch),
                ..._cubes.animCubes,
              ],
            ),
          ),
          GestureMode.panZoom == gestureMode
              ? PanZoomer()
              : Brush(adoptCubes: _cubes.adopt),
          PageButtons(undoer: _cubes.undoer),
        ]),
      ),
    );
  }
}
