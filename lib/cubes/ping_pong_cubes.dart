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
/// TODO split into LoadingCubes and PingPongCubes
class PingPongCubes extends StatefulWidget {
  const PingPongCubes({Key? key}) : super(key: key);

  @override
  State<PingPongCubes> createState() => PingPongCubesState();
}

class PingPongCubesState extends State<PingPongCubes>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    const int milliseconds = 800;

    const Duration pingPongDuration = Duration(milliseconds: milliseconds);
    _controller = AnimationController(duration: pingPongDuration, vsync: this);

    _controller.repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(PingPongCubes oldWidget) {
    final paintingBank = getPaintingBank(context);

    if (paintingBank.isAnimatingLoadedCubes) {
      _controller.repeat();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) =>
      CubesAnimatedBuilder(isPingPong: true, controller: _controller);
}
