import 'package:cube_painter/buttons/page_buttons.dart';
import 'package:cube_painter/colors.dart';
import 'package:cube_painter/cubes/anim_cubes.dart';
import 'package:cube_painter/cubes/static_cube.dart';
import 'package:cube_painter/gestures/gesturer.dart';
import 'package:cube_painter/gestures/pan_zoom.dart';
import 'package:cube_painter/horizon.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/paintings_menu.dart';
import 'package:cube_painter/persisted/painting_bank.dart';
import 'package:cube_painter/slices_menu.dart';
import 'package:cube_painter/transform/unit_to_screen.dart';
import 'package:flutter/material.dart';

/// prevent 'organise imports' from removing imports
/// when temporarily commenting out.
const noWarn = [
  out,
  PanZoomer,
  StaticCubes,
];

class PainterPage extends StatelessWidget {
  const PainterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final paintingBank = getPaintingBank(context, listen: true);

    return Scaffold(
      drawer: const PaintingsMenu(),
      endDrawer: const SlicesMenu(),
      drawerEnableOpenDragGesture: false,
      body: Container(
        color: backgroundColor,
        child: SafeArea(
          left: false,
          child: Stack(children: [
            UnitToScreen(
              child: Stack(
                children: [
                  Transform.scale(scale: 30, child: const Horizon()),
                  if (paintingBank.hasCubes &&
                      !paintingBank.isAnimatingLoadedCubes)
                    StaticCubes(painting: paintingBank.painting),
                  // const CurrentStaticCubes(),
                ],
              ),
            ),
            if (paintingBank.animCubeInfos.isNotEmpty)
              AnimCubes(
                cubeInfos: paintingBank.animCubeInfos,
                isPingPong: paintingBank.isPingPong,
              ),
            const Gesturer(),
            const PageButtons(),
          ]),
        ),
      ),
    );
  }
}
