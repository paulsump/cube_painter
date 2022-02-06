import 'package:cube_painter/shared/grid_point.dart';
import 'package:cube_painter/shared/grid_transform.dart';
import 'package:cube_painter/shared/screen_transform.dart';
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

    return Transform.translate(
      // offset: Offset(Screen.width/2, Screen.height/2 ),
      offset: Offset(0, Screen.height),
      child: Transform.scale(
        scale: getZoomScale(context),
        child: Stack(
          children: [
            const Grid(),
            Transform.translate(
              offset: gridStep,
              child: const Cube(),
            ),
            const Cube(),
            Transform.translate(
              offset: gridStep * 3,
              child: const AnimatedCube(),
            ),
          ],
        ),
      ),
    );
  }
}
