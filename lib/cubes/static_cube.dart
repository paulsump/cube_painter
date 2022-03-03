import 'package:cube_painter/cubes/slice_unit_cube.dart';
import 'package:cube_painter/cubes/whole_unit_cube.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/persisted/cube_info.dart';
import 'package:cube_painter/persisted/painting.dart';
import 'package:cube_painter/persisted/slice.dart';
import 'package:cube_painter/transform/position_to_unit.dart';
import 'package:flutter/material.dart';

const noWarn = [out];

/// The entire painting is with this.
/// It has a list of [_PositionedUnitCube]s.
/// It draws them in the order they were added.
class StaticCubes extends StatelessWidget {
  final List<_PositionedUnitCube> _cubes;

  StaticCubes({
    Key? key,
    required Painting painting,
  })  : _cubes = List.generate(painting.cubeInfos.length,
            (i) => _PositionedUnitCube(info: painting.cubeInfos[i])),
        super(key: key);

  @override
  Widget build(BuildContext context) =>
      _cubes.isEmpty ? Container(color: Colors.red) : Stack(children: _cubes);
}

/// A cube that has been positioned
class _PositionedUnitCube extends StatelessWidget {
  final CubeInfo info;

  const _PositionedUnitCube({Key? key, required this.info}) : super(key: key);

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
