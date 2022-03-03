import 'package:cube_painter/cubes/positioned_scaled_cube.dart';
import 'package:cube_painter/cubes/unit_ping_pong.dart';
import 'package:cube_painter/persisted/cube_info.dart';
import 'package:cube_painter/transform/unit_to_screen.dart';
import 'package:flutter/material.dart';

class CubesAnimatedBuilder extends StatelessWidget {
  final AnimationController _controller;
  final List<CubeInfo> cubeInfos;

  const CubesAnimatedBuilder({
    Key? key,
    required AnimationController controller,
    required this.cubeInfos,
  })  : _controller = controller,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final int n = cubeInfos.length;

        double unitPingPong(i) => calcUnitPingPong(_controller.value + i / n);

        return Stack(
          children: [
            UnitToScreen(
              child: Stack(
                children: [
                  for (int i = 0; i < n; ++i)
                    PositionedScaledCube(
                      scale: lerp(unitPingPong(i), 1.0, _controller.value),
                      info: cubeInfos[i],
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
