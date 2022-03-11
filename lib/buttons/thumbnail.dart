// Copyright (c) 2022, Paul Sumpner.  All rights reserved.

import 'package:cube_painter/cubes/calc_unit_ping_pong.dart';
import 'package:cube_painter/cubes/positioned_scaled_cube.dart';
import 'package:cube_painter/cubes/slice_unit_cube.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/persisted/painting.dart';
import 'package:cube_painter/transform/position_to_unit.dart';
import 'package:flutter/material.dart';

const noWarn = out;

/// Auto generated (painted) thumbnail of a [Painting]
/// Used on the buttons on the [PaintingsMenu]
/// 'Unit' means this thumbnail has size of 1
class Thumbnail extends StatelessWidget {
  const Thumbnail({
    Key? key,
    required this.painting,
    required UnitTransform unitTransform,
    required this.isPingPong,
    this.wire = false,
  })  : _unitTransform = unitTransform,
        super(key: key);

  final Painting painting;
  final UnitTransform _unitTransform;

  final bool isPingPong;
  final bool wire;

  Thumbnail.useTransform({
    Key? key,
    required Painting painting,
    bool wire = false,
  }) : this(
    key: key,
    painting: painting,
    unitTransform: painting.unitTransform,
    isPingPong: false,
    wire: wire,
  );

  @override
  Widget build(BuildContext context) {
    return painting.cubeInfos.isNotEmpty
        ? Transform.scale(
      scale: _unitTransform.scale,
      child: Transform.translate(
        offset: _unitTransform.offset,
        child: isPingPong

        /// Note that this only animates the first cube.
        /// That's all that's needed currently.
            ? _StandAloneAnimatedCube(
          unitCube:
          SliceUnitCube(slice: painting.cubeInfos[0].slice),
          offset:
          positionToUnitOffset(painting.cubeInfos[0].center),
        )
            : Stack(children: [
          ...painting.cubeInfos.map((cubeInfo) =>
              PositionedScaledCube(
                  info: cubeInfo, wire: wire, scale: 1.0))
        ]),
      ),
    )
        : Container();
  }
}

/// Unit cube or slice that animates itself based the fields passed in.
/// Used on the [_SlicesExamplePainting] only now that I have [GrowingCubes] and [BrushCubes]
class _StandAloneAnimatedCube extends StatefulWidget {
  const _StandAloneAnimatedCube({
    Key? key,
    required this.unitCube,
    required this.offset,
  }) : super(key: key);

  final Widget unitCube;
  final Offset offset;

  @override
  _StandAloneAnimatedCubeState createState() => _StandAloneAnimatedCubeState();
}

class _StandAloneAnimatedCubeState extends State<_StandAloneAnimatedCube>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
        duration: const Duration(milliseconds: 3000), vsync: this);

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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: [
            Transform.translate(
              offset: widget.offset,
              child: Transform.scale(
                scale: calcUnitPingPong(_controller.value),
                child: widget.unitCube,
              ),
            ),
          ],
        );
      },
    );
  }
}
