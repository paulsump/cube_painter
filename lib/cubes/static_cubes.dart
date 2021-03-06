// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'package:cube_painter/cubes/slice_unit_cube.dart';
import 'package:cube_painter/cubes/whole_unit_cube.dart';
import 'package:cube_painter/persisted/animator.dart';
import 'package:cube_painter/persisted/cube_info.dart';
import 'package:cube_painter/persisted/painting_bank.dart';
import 'package:cube_painter/persisted/slice.dart';
import 'package:cube_painter/transform/position_to_unit.dart';
import 'package:cube_painter/transform/unit_to_screen.dart';
import 'package:flutter/material.dart';

/// The current painting is drawn with this.
/// It draws them in the order they were added.
class StaticCubes extends StatelessWidget {
  const StaticCubes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final paintingBank = getPaintingBank(context, listen: true);

    return UnitToScreen(
      child: Stack(children: [
        if (paintingBank.hasCubes &&
            paintingBank.cubeAnimState != CubeAnimState.loading)
          for (final cubeInfo in paintingBank.painting.cubeInfos)
            _PositionedUnitCube(info: cubeInfo)
      ]),
    );
  }
}

/// A cube that has been positioned
class _PositionedUnitCube extends StatelessWidget {
  const _PositionedUnitCube({Key? key, required this.info}) : super(key: key);

  final CubeInfo info;

  @override
  Widget build(BuildContext context) {
    final Offset offset = positionToUnitOffset(info.center);

    return Transform.translate(
      offset: offset,
      child: info.slice == Slice.whole
          ? const WholeUnitCube()
          : SliceUnitCube(slice: info.slice),
    );
  }
}
