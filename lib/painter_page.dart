import 'package:cube_painter/brush/brush.dart';
import 'package:cube_painter/buttons/page_buttons.dart';
import 'package:cube_painter/colors.dart';
import 'package:cube_painter/cubes/animated_scale_cubes.dart';
import 'package:cube_painter/cubes/cubes.dart';
import 'package:cube_painter/cubes/static_cube.dart';
import 'package:cube_painter/gesture_mode.dart';
import 'package:cube_painter/horizon.dart';
import 'package:cube_painter/menu/paintings_menu.dart';
import 'package:cube_painter/menu/slices_menu.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/persisted/sketch_bank.dart';
import 'package:cube_painter/persisted/slice.dart';
import 'package:cube_painter/transform/pan_zoom.dart';
import 'package:cube_painter/transform/unit_to_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// prevent 'organise imports' from removing imports
/// when temporarily commenting out.
const noWarn = [
  out,
  PanZoomer,
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
    final sketchBank = getSketchBank(context, listen: true);

    final gestureMode = getGestureMode(context, listen: true);

    return Scaffold(
      drawer: const PaintingsMenu(),
      endDrawer: const SlicesMenu(),
      drawerEnableOpenDragGesture: false,
      body: Container(
        color: backgroundColor,
        child: SafeArea(
          left: false,
          child: Stack(children: [
            const UnitToScreenHorizon(child: Horizon()),
            UnitToScreen(
              child: Stack(
                children: [
                  // HACK FOR testing
                  if (sketchBank.hasCubes)
                    StaticCubes(sketch: sketchBank.sketch),
                  ..._cubes.animCubes,
                ],
              ),
            ),
            if (sketchBank.hasCubes)
              AnimatedScaleCubes(cubeInfos: sketchBank.sketch.cubeInfos),
            GestureMode.panZoom == gestureMode
                ? PanZoomer()
                : Brush(adoptCubes: _cubes.adopt),
            PageButtons(undoer: _cubes.undoer),
          ]),
        ),
      ),
    );
  }
}
