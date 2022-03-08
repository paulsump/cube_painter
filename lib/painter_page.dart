import 'package:cube_painter/buttons/page_buttons.dart';
import 'package:cube_painter/cubes/brush_cubes.dart';
import 'package:cube_painter/cubes/growing_cubes.dart';
import 'package:cube_painter/cubes/static_cubes.dart';
import 'package:cube_painter/gestures/gesturer.dart';
import 'package:cube_painter/gestures/helper_lines.dart';
import 'package:cube_painter/horizon.dart';
import 'package:cube_painter/hue.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/paintings_menu.dart';
import 'package:cube_painter/persisted/animator.dart';
import 'package:cube_painter/persisted/painting_bank.dart';
import 'package:cube_painter/slices_menu.dart';
import 'package:flutter/material.dart';

const noWarn = [out];

/// The only page in this app.
/// Paint cubes using a [Brusher] (part of [Gesturer]
/// change the [Brush] with [PageButtons]
/// While brushing (adding cubes)
/// or loading a [Painting] from the [PaintingsMenu]
/// [_AnimatedCubes] will animate.
/// When brushing or loading has finished,
/// [StaticCubes] show the full contents of the [Painting].
class PainterPage extends StatelessWidget {
  const PainterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const PaintingsMenu(),
      endDrawer: const SlicesMenu(),
      drawerEnableOpenDragGesture: false,
      drawerScrimColor: Hue.scrim,
      body: Container(
        color: Hue.background,
        child: SafeArea(
          left: false,
          child: Stack(children: const [
            Horizon(),
            StaticCubes(),
            HelperLines(),
            _AnimatingCubes(),
            Gesturer(),
            PageButtons(),
          ]),
        ),
      ),
    );
  }
}

/// While brushing (adding cubes)
/// or loading a [Painting] from the [PaintingsMenu]
/// [_AnimatedCubes] will animate.
class _AnimatingCubes extends StatelessWidget {
  const _AnimatingCubes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final paintingBank = getPaintingBank(context, listen: true);

    return Stack(
      children: [
        if (paintingBank.animCubeInfos.isNotEmpty)
          if (CubeAnimState.brushing == paintingBank.cubeAnimState)
            const BrushCubes()
          else
            const GrowingCubes(),
      ],
    );
  }
}
