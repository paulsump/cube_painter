import 'dart:ui';

import 'package:cube_painter/cubes/calc_unit_ping_pong.dart';
import 'package:cube_painter/cubes/positioned_scaled_cube.dart';
import 'package:cube_painter/gestures/brush.dart';
import 'package:cube_painter/persisted/animator.dart';
import 'package:cube_painter/persisted/painting_bank.dart';
import 'package:cube_painter/transform/unit_to_screen.dart';
import 'package:flutter/material.dart';

/// Builds the [AnimatedBuilder] part of the animation
/// shared in [BrushCubes] and [GrowingCubes].
/// Though [BrushCubes] repeats and [GrowingCubes] just goes forward,
/// they both animate cubes in the same way.
class CubesAnimatedBuilder extends StatelessWidget {
  const CubesAnimatedBuilder({
    Key? key,
    required AnimationController controller,
    required this.isPingPong,
  })  : _controller = controller,
        super(key: key);

  final AnimationController _controller;
  final bool isPingPong;

  @override
  Widget build(BuildContext context) {
    final paintingBank = getPaintingBank(context, listen: true);

    final brush = getBrush(context);
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final int n = paintingBank.animCubeInfos.length;

        double unitPingPong(i) => calcUnitPingPong(_controller.value + i / n);

        return Stack(
          children: [
            UnitToScreen(
              child: Stack(
                children: [
                  for (int i = 0; i < n; ++i)
                    PositionedScaledCube(
                      scale: isPingPong
                          ? unitPingPong(i)
                          : lerpDouble(
                              unitPingPong(i), 1.0, _controller.value)!,
                      info: paintingBank.animCubeInfos[i],
                      wire: brush == Brush.eraseLine &&
                          CubeAnimState.brushing == paintingBank.cubeAnimState,
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
