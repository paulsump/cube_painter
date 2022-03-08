import 'package:cube_painter/cubes/cubes_animated_builder.dart';
import 'package:cube_painter/cubes/done_cubes.dart';
import 'package:cube_painter/cubes/positioned_scaled_cube.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/persisted/position.dart';
import 'package:flutter/material.dart';

const noWarn = [out, Position];

/// Animates a list of [PositionedScaledCube]s.
/// Used when brushing (creating using gestures).
/// The cubes are moved to [StaticCubes] externally
/// via [finishAnim]
class BrushCubes extends StatefulWidget {
  const BrushCubes({Key? key}) : super(key: key);

  @override
  State<BrushCubes> createState() => BrushCubesState();
}

class BrushCubesState extends State<BrushCubes>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    const Duration pingPongDuration = Duration(milliseconds: 800);

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
  Widget build(BuildContext context) =>
      CubesAnimatedBuilder(isPingPong: true, controller: _controller);
}
