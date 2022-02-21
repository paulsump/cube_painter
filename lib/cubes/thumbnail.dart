import 'package:cube_painter/colors.dart';
import 'package:cube_painter/cubes/static_cube.dart';
import 'package:cube_painter/data/cube_group.dart';
import 'package:flutter/material.dart';

class Thumbnail extends StatelessWidget {
  final CubeGroup cubeGroup;

  const Thumbnail({Key? key, required this.cubeGroup}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.transparent,
      color: backgroundColor,
      width: 99,
      height: 99,
      child: Transform.translate(
        offset: Offset(203, 63),
        child: Transform.scale(
          scale: 1.9,
          child: StaticCubes(cubeGroup: cubeGroup),
        ),
      ),
    );
  }
}
