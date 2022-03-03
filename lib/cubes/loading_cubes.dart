import 'package:cube_painter/cubes/positioned_scaled_cube.dart';
import 'package:cube_painter/cubes/static_cube.dart';
import 'package:cube_painter/cubes/unit_ping_pong.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/persisted/cube_info.dart';
import 'package:cube_painter/persisted/painting_bank.dart';
import 'package:cube_painter/persisted/position.dart';
import 'package:cube_painter/transform/unit_to_screen.dart';
import 'package:flutter/material.dart';

const noWarn = [out, Position];

/// Animates a list of [PositionedScaledCube]s.
/// Used when loading and brushing (creating using gestures).
/// One animator controls them all.
/// The cubes are moved to [StaticCubes] either externally
/// via [finishAnim] or [whenComplete] after the animation is finished.
/// Stateful because of SingleTickerProviderStateMixin
class LoadingCubes extends StatefulWidget {
  final List<CubeInfo> cubeInfos;

  const LoadingCubes({
    Key? key,
    required this.cubeInfos,
  }) : super(key: key);

  @override
  State<LoadingCubes> createState() => AnimCubesState();
}

class AnimCubesState extends State<LoadingCubes>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  static const int milliseconds = 800;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);

    startForwardAnim(fromZero: true);
    super.initState();
  }

  void startForwardAnim({required bool fromZero}) {
    if (_controller.value != 1) {
      _controller.duration =
          Duration(milliseconds: 2 * milliseconds ~/ (1 - _controller.value));
    }

    _controller.forward(from: fromZero ? 0 : _controller.value).whenComplete(
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
  void didUpdateWidget(LoadingCubes oldWidget) {
    final paintingBank = getPaintingBank(context);

    if (paintingBank.isAnimatingLoadedCubes ||
        oldWidget.cubeInfos != widget.cubeInfos) {
      if (paintingBank.isPingPong) {
        out('l');
      } else {
        startForwardAnim(fromZero: paintingBank.isAnimatingLoadedCubes);
      }
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final int n = widget.cubeInfos.length;

        double unitPingPong(i) => calcUnitPingPong(_controller.value + i / n);

        return Stack(
          children: [
            UnitToScreen(
              child: Stack(
                children: [
                  for (int i = 0; i < n; ++i)
                    PositionedScaledCube(
                      scale: lerp(unitPingPong(i), 1.0, _controller.value),
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

