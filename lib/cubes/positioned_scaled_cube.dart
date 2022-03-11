// Copyright (c) 2022, Paul Sumpner.  All rights reserved.

import 'package:cube_painter/cubes/slice_unit_cube.dart';
import 'package:cube_painter/cubes/whole_unit_cube.dart';
import 'package:cube_painter/cubes/wire_unit_cube.dart';
import 'package:cube_painter/persisted/cube_info.dart';
import 'package:cube_painter/persisted/slice.dart';
import 'package:cube_painter/transform/position_to_unit.dart';
import 'package:flutter/material.dart';

/// A cube that has been positioned and scale
/// Similar to [_PositionedUnitCube], but scaled too.
/// This allows the cube to animate bigger an smaller.
class PositionedScaledCube extends StatelessWidget {
  const PositionedScaledCube({
    Key? key,
    required this.info,
    required this.scale,
    required this.wire,
  }) : super(key: key);

  final CubeInfo info;
  final double scale;

  final bool wire;

  @override
  Widget build(BuildContext context) {
    final Offset offset = positionToUnitOffset(info.center);

    return Transform.translate(
      offset: offset,
      child: Transform.scale(
        scale: scale,
        child: info.slice == Slice.whole
            ? wire
            ? const WireUnitCube()
            : const WholeUnitCube()
            : SliceUnitCube(slice: info.slice),
      ),
    );
  }
}
