import 'package:cube_painter/cubes/slice_unit_cube.dart';
import 'package:cube_painter/cubes/static_cube.dart';
import 'package:cube_painter/cubes/unit_ping_pong.dart';
import 'package:cube_painter/cubes/whole_unit_cube.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/persisted/cube_info.dart';
import 'package:cube_painter/persisted/painting_bank.dart';
import 'package:cube_painter/persisted/position.dart';
import 'package:cube_painter/persisted/slice.dart';
import 'package:cube_painter/transform/position_to_unit.dart';
import 'package:cube_painter/transform/unit_to_screen.dart';
import 'package:flutter/material.dart';

const noWarn = [out, Position];

/// Animates a list of [_PositionedScaledCube]s.
/// Used when loading and brushing (creating using gestures).
/// One animator controls them all.
/// The cubes are moved to [StaticCubes] either externally
/// via [finishAnim] or [whenComplete] after the animation is finished.
/// Stateful because of SingleTickerProviderStateMixin
/// TODO split into LoadingCubes and PingPongCubes
class PingPongCubes extends StatefulWidget {
  final List<CubeInfo> cubeInfos;

  const PingPongCubes({
    Key? key,
    required this.cubeInfos,
  }) : super(key: key);

  @override
  State<PingPongCubes> createState() => AnimCubesState();
}

class AnimCubesState extends State<PingPongCubes>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    const int milliseconds = 800;
    const Duration pingPongDuration = Duration(milliseconds: milliseconds);

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
  void didUpdateWidget(PingPongCubes oldWidget) {
    final paintingBank = getPaintingBank(context);

    if (paintingBank.isAnimatingLoadedCubes ||
        oldWidget.cubeInfos != widget.cubeInfos) {
      if (paintingBank.isPingPong) {
        _controller.repeat();
      } else {
        out('p');
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
                    _PositionedScaledCube(
                      scale: unitPingPong(i),
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

/// A cube that has been positioned and scale
/// Similar to [_PositionedUnitCube], but scaled too.
/// This allows the cube to animate bigger an smaller.
class _PositionedScaledCube extends StatelessWidget {
  final CubeInfo info;
  final double scale;

  const _PositionedScaledCube({
    Key? key,
    required this.info,
    required this.scale,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Offset offset = positionToUnitOffset(info.center);

    return Transform.translate(
      offset: offset,
      child: Transform.scale(
        scale: scale,
        child: info.slice == Slice.whole
            ? const WholeUnitCube()
            : SliceUnitCube(slice: info.slice),
      ),
    );
  }
}
