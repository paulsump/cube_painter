import 'package:cube_painter/cubes/cubes_animated_builder.dart';
import 'package:cube_painter/cubes/positioned_scaled_cube.dart';
import 'package:cube_painter/cubes/static_cube.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/persisted/painting_bank.dart';
import 'package:cube_painter/persisted/position.dart';
import 'package:flutter/material.dart';

const noWarn = [out, Position];

/// Animates a list of [PositionedScaledCube]s.
/// Used when loading and brushing (creating using gestures).
/// One animator controls them all.
/// The cubes are moved to [StaticCubes] either externally
/// via [finishAnim] or [whenComplete] after the animation is finished.
/// Stateful because of SingleTickerProviderStateMixin
class LoadingCubes extends StatefulWidget {
  const LoadingCubes({Key? key}) : super(key: key);

  @override
  State<LoadingCubes> createState() => LoadingCubesState();
}

class LoadingCubesState extends State<LoadingCubes>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  static const int milliseconds = 800;

  @override
  void initState() {
    const int milliseconds = 800;
    const Duration pingPongDuration = Duration(milliseconds: milliseconds);

    _controller = AnimationController(duration: pingPongDuration, vsync: this);

    startForwardAnim();
    super.initState();
  }

  void startForwardAnim() {
    _controller.forward(from: 0).whenComplete(
      () {
        final paintingBank = getPaintingBank(context);

        paintingBank.finishAnim();
        paintingBank.isAnimatingLoadedCubes = false;
      },
    );
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
