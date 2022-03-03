import 'package:cube_painter/cubes/positioned_scaled_cube.dart';
import 'package:cube_painter/cubes/unit_ping_pong.dart';
import 'package:cube_painter/persisted/painting_bank.dart';
import 'package:cube_painter/transform/unit_to_screen.dart';
import 'package:flutter/material.dart';

class CubesAnimatedBuilder extends StatelessWidget {
  final AnimationController _controller;

  final bool isPingPong;

  const CubesAnimatedBuilder({
    Key? key,
    required AnimationController controller,
    required this.isPingPong,
  })  : _controller = controller,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final paintingBank = getPaintingBank(context, listen: true);

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
                          : lerp(unitPingPong(i), 1.0, _controller.value),
                      info: paintingBank.animCubeInfos[i],
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
