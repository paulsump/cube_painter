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
/// TODO split into LoadingCubes and PingPongCubes
class AnimCubes extends StatefulWidget {
  final List<CubeInfo> cubeInfos;

  final bool isPingPong;

  const AnimCubes({
    Key? key,
    required this.cubeInfos,
    required this.isPingPong,
  }) : super(key: key);

  @override
  State<AnimCubes> createState() => AnimCubesState();
}

class AnimCubesState extends State<AnimCubes>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  static const int milliseconds = 800;
  static const Duration pingPongDuration = Duration(milliseconds: milliseconds);

  @override
  void initState() {
    _controller = AnimationController(duration: pingPongDuration, vsync: this);

    if (widget.isPingPong) {
      _controller.repeat();
    } else {
      startForwardAnim(fromZero: true);
    }
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

        // set back to default for next time
        _controller.duration = pingPongDuration;
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(AnimCubes oldWidget) {
    final paintingBank = getPaintingBank(context);

    if (paintingBank.isAnimatingLoadedCubes ||
        oldWidget.isPingPong != widget.isPingPong ||
        oldWidget.cubeInfos != widget.cubeInfos) {
      if (paintingBank.isPingPong) {
        _controller.duration = pingPongDuration;

        _controller.repeat();
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
                      scale: widget.isPingPong
                          ? unitPingPong(i)
                          : lerp(unitPingPong(i), 1.0, _controller.value),
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
