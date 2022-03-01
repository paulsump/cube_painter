import 'dart:async';

import 'package:cube_painter/brush/gesturer.dart';
import 'package:cube_painter/buttons/page_buttons.dart';
import 'package:cube_painter/colors.dart';
import 'package:cube_painter/cubes/animated_scale_cubes.dart';
import 'package:cube_painter/cubes/static_cube.dart';
import 'package:cube_painter/gesture_mode.dart';
import 'package:cube_painter/horizon.dart';
import 'package:cube_painter/menu/paintings_menu.dart';
import 'package:cube_painter/menu/slices_menu.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/persisted/cube_info.dart';
import 'package:cube_painter/persisted/position.dart';
import 'package:cube_painter/persisted/sketch_bank.dart';
import 'package:cube_painter/persisted/slice.dart';
import 'package:cube_painter/transform/pan_zoom.dart';
import 'package:cube_painter/transform/unit_to_screen.dart';
import 'package:cube_painter/undoer.dart';
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
  late Undoer undoer;

  void _addToAnimCubeInfos() {
    final sketchBank = getSketchBank(context);

    final List<CubeInfo> cubeInfos = sketchBank.sketch.cubeInfos;

    sketchBank.addAllToAnimCubeInfos(cubeInfos.toList());
    cubeInfos.clear();
  }

  @override
  void initState() {
    unawaited(getSketchBank(context).init(
      onSuccessfulLoad: () {
        undoer.clear();
        _addToAnimCubeInfos();
      },
    ));

    //TODO UNdoer doesn't need setstate now that it's all done in sketchBank
    undoer = Undoer(context, setState: setState);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final sketchBank = getSketchBank(context, listen: true);

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
                ],
              ),
            ),
            if (sketchBank.animCubeInfos.isNotEmpty)
              AnimatedScaleCubes(
                cubeInfos: sketchBank.animCubeInfos,
                pingPong: sketchBank.pingPong,
              ),
            const Gesturer(),
            PageButtons(undoer: undoer),
          ]),
        ),
      ),
    );
  }

  //todo undo and erase
  //todo when i put undoer in a provider, i can move this function to SketchBank
  void adopt() {
    final bool erase = GestureMode.erase == getGestureMode(context);
    final sketchBank = getSketchBank(context);

    final List<CubeInfo> cubeInfos = sketchBank.sketch.cubeInfos;

    if (erase) {
      final orphans = sketchBank.animCubeInfos;

      for (final CubeInfo orphan in orphans) {
        final CubeInfo? cubeInfo = _getCubeInfoAt(orphan.center, cubeInfos);

        if (cubeInfo != null) {
          assert(orphans.length == 1);

          undoer.save();
          cubeInfos.remove(cubeInfo);
        }
      }
    } else {
      undoer.save();
    }
  }

  CubeInfo? _getCubeInfoAt(Position position, List<CubeInfo> cubeInfos) {
    for (final info in cubeInfos) {
      if (position == info.center) {
        return info;
      }
    }
    return null;
  }
}
