import 'package:cube_painter/cubes/standalone_animated_cube.dart';
import 'package:cube_painter/cubes/static_cube.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/persisted/sketch.dart';
import 'package:flutter/material.dart';

const noWarn = out;

/// Auto generated (painted) thumbnail of a [Sketch]
/// Used on the buttons on the [PaintingsMenu]
/// 'Unit' means this thumbnail has size of 1
class Thumbnail extends StatelessWidget {
  final Sketch sketch;

  final UnitTransform _unitTransform;

  const Thumbnail({
    Key? key,
    required this.sketch,
    required UnitTransform unitTransform,
  })  : _unitTransform = unitTransform,
        super(key: key);

  Thumbnail.useTransform({Key? key, required this.sketch})
      : _unitTransform = sketch.unitTransform,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return sketch.cubeInfos.isNotEmpty
        ? Transform.scale(
            scale: _unitTransform.scale,
            child: Transform.translate(
                offset: _unitTransform.offset,
                // TODO REMove hack for example slice
                child: sketch.cubeInfos.length == 1
                    ? StandAloneAnimatedCube(info: sketch.cubeInfos[0])
                    : StaticCubes(sketch: sketch)),
          )
        : Container();
  }
}
