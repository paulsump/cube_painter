import 'package:cube_painter/buttons/page_buttons.dart';
import 'package:cube_painter/colors.dart';
import 'package:cube_painter/cubes/brush_line_cubes.dart';
import 'package:cube_painter/cubes/growing_cubes.dart';
import 'package:cube_painter/cubes/static_cube.dart';
import 'package:cube_painter/gestures/gesturer.dart';
import 'package:cube_painter/horizon.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/paintings_menu.dart';
import 'package:cube_painter/persisted/animator.dart';
import 'package:cube_painter/persisted/painting_bank.dart';
import 'package:cube_painter/slices_menu.dart';
import 'package:flutter/material.dart';

/// prevent 'organise imports' from removing imports
/// when temporarily commenting out.
const noWarn = [out];

class PainterPage extends StatelessWidget {
  const PainterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const PaintingsMenu(),
      endDrawer: const SlicesMenu(),
      drawerEnableOpenDragGesture: false,
      body: Container(
        color: backgroundColor,
        child: SafeArea(
          left: false,
          child: Stack(children: const [
            Horizon(),
            DoneCubes(),
            _AnimCubes(),
            Gesturer(),
            PageButtons(),
          ]),
        ),
      ),
    );
  }
}

class _AnimCubes extends StatelessWidget {
  const _AnimCubes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final paintingBank = getPaintingBank(context, listen: true);

    return Stack(
      children: [
        if (paintingBank.animCubeInfos.isNotEmpty)
        //TODO FIx CubeState.growing is only for load
          if (paintingBank.cubeState == CubeState.brushLine)
            const BrushLineCubes()
          else
            const GrowingCubes(),
      ],
    );
  }
}
