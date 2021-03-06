// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'package:cube_painter/cubes/cubes_animated_builder.dart';
import 'package:cube_painter/cubes/positioned_scaled_cube.dart';
import 'package:cube_painter/cubes/static_cubes.dart';
import 'package:cube_painter/persisted/animator.dart';
import 'package:cube_painter/persisted/painting_bank.dart';
import 'package:flutter/material.dart';

/// Animates a list of [PositionedScaledCube]s.
/// Used when growing the cubes up to there static size.
/// The cubes are moved to [StaticCubes] either externally
/// via [finishAnim] or [whenComplete] after the animation is finished.
class GrowingCubes extends StatefulWidget {
  const GrowingCubes({Key? key}) : super(key: key);

  @override
  State<GrowingCubes> createState() => GrowingCubesState();
}

class GrowingCubesState extends State<GrowingCubes>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
        duration: const Duration(milliseconds: 800), vsync: this);
    _controller.forward().whenComplete(
          () {
        final paintingBank = getPaintingBank(context);

        paintingBank.finishAnim();
        paintingBank.cubeAnimState = CubeAnimState.growingOrStatic;
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      CubesAnimatedBuilder(isPingPong: false, controller: _controller);
}
