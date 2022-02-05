import 'package:cube_painter/shared/grid_point.dart';
import 'package:cube_painter/shared/grid_transform.dart';
import 'package:cube_painter/shared/screen.dart';
import 'package:cube_painter/widgets/animated_cube.dart';
import 'package:cube_painter/widgets/cube.dart';
import 'package:cube_painter/widgets/grid.dart';
import 'package:flutter/material.dart';

class PainterPage extends StatelessWidget {
  const PainterPage({
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final Offset offset = toOffset(const GridPoint(1, 1));
    return Transform.translate(
      offset: Offset(Screen.width/2, Screen.height/2 ),
      child: Transform.scale(
        // TODO zoom
        scale: 33,
        child: Stack(
          children: [
            const Grid(),
            Transform.translate(
              offset: offset,
              child: const Cube(),
            ),
            const Cube(),
            Transform.translate(
              offset: offset*3,
              child: const AnimatedCube(),
            ),
          ],
        ),
      ),
    );
  }
}
