import 'dart:math';

import 'package:cube_painter/cubes/static_cube.dart';
import 'package:cube_painter/gesture_mode.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/persisted/cube_info.dart';
import 'package:cube_painter/persisted/position.dart';
import 'package:cube_painter/persisted/sketch_bank.dart';
import 'package:cube_painter/transform/unit_to_screen.dart';
import 'package:cube_painter/unit_ping_pong.dart';
import 'package:flutter/material.dart';

const noWarn = [out, Position];

class AnimatedScaleCubes extends StatefulWidget {
  final List<CubeInfo> cubeInfos;

  final bool pingPong;

  const AnimatedScaleCubes({
    Key? key,
    required this.cubeInfos,
    this.pingPong = false,
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

    if (widget.pingPong) {
      _controller.repeat();
    } else {
      startForwardAnim();
    }
    super.initState();
  }

  void startForwardAnim() {
    _controller.forward(from: 0).whenComplete(() {
      final sketchBank = getSketchBank(context);
      sketchBank.addAllAnimCubeInfosToStaticCubeInfos();
      sketchBank.setPlaying(false);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(AnimatedScaleCubes oldWidget) {
    if (getSketchBank(context).playing) {
      startForwardAnim();
    }

    super.didUpdateWidget(oldWidget);
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
                      scale: widget.pingPong
                          ? pingPongBetween(
                              start, end, _controller.value + i / n)
                          : min(1, lerp(start, end, _controller.value + i / n)),
                      // scale: (widget.pingPong ? pingPongBetween : lerp)(
                      //     start, end, _controller.value + i / n),
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
