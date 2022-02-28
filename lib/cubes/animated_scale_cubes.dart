import 'package:cube_painter/cubes/static_cube.dart';
import 'package:cube_painter/gesture_mode.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/persisted/cube_info.dart';
import 'package:cube_painter/persisted/position.dart';
import 'package:cube_painter/transform/unit_to_screen.dart';
import 'package:cube_painter/unit_ping_pong.dart';
import 'package:flutter/material.dart';

const noWarn = [out, Position];

class AnimatedScaleCubes extends StatefulWidget {
  final List<CubeInfo> cubeInfos;

  const AnimatedScaleCubes({
    Key? key,
    required this.cubeInfos,
  }) : super(key: key);

  @override
  State<AnimatedScaleCubes> createState() => AnimatedScaleCubesState();
}

class AnimatedScaleCubesState extends State<AnimatedScaleCubes>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final double start = 0.0;

  double get end => GestureMode.addWhole == getGestureMode(context) ? 1.0 : 3.0;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _controller.repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int n = widget.cubeInfos.length;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: [
            // HACK without this container,
            // onPanStart etc doesn't get called after cubes are added.
            // Container(),
            UnitToScreen(
              child: Stack(
                children: [
                  for (int i = 0; i < n; ++i)
                    ScaledCube(
                      scale: pingPongBetween(
                          start, end, _controller.value + 1 * i / n),
                      info: widget.cubeInfos[i],
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
