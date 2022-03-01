import 'dart:math';

import 'package:cube_painter/cubes/static_cube.dart';
import 'package:cube_painter/cubes/unit_ping_pong.dart';
import 'package:cube_painter/gesture_mode.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/persisted/cube_info.dart';
import 'package:cube_painter/persisted/position.dart';
import 'package:cube_painter/persisted/sketch_bank.dart';
import 'package:cube_painter/transform/unit_to_screen.dart';
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
      startForwardAnim(fromZero: true);
    }
    super.initState();
  }

  double prevValue = 0;

  void startForwardAnim({required bool fromZero}) {
    prevValue = _controller.value;
    _controller.duration = const Duration(milliseconds: 1600);
    _controller
        // .forward(from: fromZero ? 0 : _controller.value)
        .forward(from: 0)
        .whenComplete(() {
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
    final sketchBank = getSketchBank(context);

    if (sketchBank.playing && !sketchBank.pingPong) {
      startForwardAnim(fromZero: false);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final int n = widget.cubeInfos.length;
        double pingPongTween(i) =>
            pingPongBetween(start, end, _controller.value + i / n);
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
                          ? pingPongTween(i)
                          : min(
                              1,
                              lerp(pingPongTween(i), pingPongTween(i) + 1,
                                  _controller.value + prevValue)),
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
