import 'package:cube_painter/cubes/anim_cube.dart';
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

  final UnitTransform unitTransform;

  const Thumbnail({
    Key? key,
    required this.sketch,
    required this.unitTransform,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return sketch.cubeInfos.isNotEmpty
        ? Transform.scale(
      scale: unitTransform.scale,
            child: Transform.translate(
                offset: unitTransform.offset,
                // TODO REMove hack for example slice
                child: sketch.cubeInfos.length == 1
                    ? AnimCube(
                        key: UniqueKey(),
                        fields: Fields(
                          info: sketch.cubeInfos[0],
                        ),
                      )
                    : StaticCubes(sketch: sketch)),
          )
        : Container();
  }
}
