import 'package:cube_painter/cubes/static_cube.dart';
import 'package:cube_painter/cubes/unit_ping_pong.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/persisted/cube_info.dart';
import 'package:cube_painter/persisted/position.dart';
import 'package:cube_painter/persisted/sketch_bank.dart';
import 'package:cube_painter/transform/unit_to_screen.dart';
import 'package:flutter/material.dart';

const noWarn = [out, Position];

class AnimCubes extends StatefulWidget {
  final List<CubeInfo> cubeInfos;

  final bool isPingPong;

  const AnimCubes({
    Key? key,
    required this.cubeInfos,
    this.isPingPong = false,
  }) : super(key: key);

  @override
  State<AnimCubes> createState() => AnimCubesState();
}

class AnimCubesState extends State<AnimCubes>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  static const int milliseconds = 800;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: milliseconds),
      vsync: this,
    );

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

    _controller
        .forward(from: fromZero ? 0 : _controller.value)
        .whenComplete(() {
      final sketchBank = getSketchBank(context);

      sketchBank.addAllAnimCubeInfosToStaticCubeInfos();
      sketchBank.setIsPlaying(false);

      sketchBank.isLoading = false;

      // set back to default for next time
      _controller.duration = const Duration(milliseconds: milliseconds);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(AnimCubes oldWidget) {
    final sketchBank = getSketchBank(context);

    if (sketchBank.isPlaying) {
      if (sketchBank.isPingPong) {
        _controller.duration = const Duration(milliseconds: milliseconds);

        _controller.repeat();
      } else {
        startForwardAnim(fromZero: false);
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

        double pingPongTween(i) => unitPingPong(_controller.value + i / n);

        return Stack(
          children: [
            UnitToScreen(
              child: Stack(
                children: [
                  for (int i = 0; i < n; ++i)
                    ScaledCube(
                      scale: widget.isPingPong
                          ? pingPongTween(i)
                          : lerp(pingPongTween(i), 1.0, _controller.value),
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
