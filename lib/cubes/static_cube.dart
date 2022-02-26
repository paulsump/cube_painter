import 'package:cube_painter/cubes/full_unit_cube.dart';
import 'package:cube_painter/cubes/slice_unit_cube.dart';
import 'package:cube_painter/data/cube_info.dart';
import 'package:cube_painter/data/sketch.dart';
import 'package:cube_painter/data/slice.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/transform/position_to_unit.dart';
import 'package:flutter/material.dart';

const noWarn = [out];

class StaticCubes extends StatelessWidget {
  final List<StaticCube> _cubes;

  StaticCubes({
    Key? key,
    required Sketch sketch,
  })  : _cubes = List.generate(sketch.cubeInfos.length,
            (i) => StaticCube(info: sketch.cubeInfos[i])),
        super(key: key);

  @override
  Widget build(BuildContext context) =>
      _cubes.isEmpty ? Container(color: Colors.red) : Stack(children: _cubes);
}

class StaticCube extends StatelessWidget {
  final CubeInfo info;

  const StaticCube({
    Key? key,
    required this.info,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Offset offset = positionToUnitOffset(info.center);

    return Transform.translate(
      offset: offset,
      child: info.slice == Slice.whole
          ? const FullUnitCube()
          : SliceUnitCube(slice: info.slice),
    );
  }
}
