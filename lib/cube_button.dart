import 'package:cube_painter/buttons/hexagon_button.dart';
import 'package:cube_painter/colors.dart';
import 'package:cube_painter/cubes/cube_sides.dart';
import 'package:cube_painter/cubes/full_unit_cube.dart';
import 'package:cube_painter/gesture_mode.dart';
import 'package:flutter/material.dart';

class CubeButton extends StatelessWidget {
  const CubeButton({
    Key? key,
    required this.gestureMode,
    required this.iconSize,
  }) : super(key: key);

  final GestureMode gestureMode;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    // final gestureMode = getGestureMode(context, listen: true);
    return HexagonButton(
        radioOn: GestureMode.add == gestureMode,
        child: Stack(
          children: [
            Transform.translate(
              offset: unit * iconSize / 2,
              child: Transform.scale(
                scale: 21,
                child: const FullUnitCube(),
              ),
            ),
            Transform.translate(
              offset: unit * -iconSize / 2,
              child: Transform.scale(
                scale: 29 / iconSize,
                child: Icon(
                  Icons.add,
                  color: getColor(Side.br),
                ),
              ),
            ),
          ],
        ),
        onPressed: () {},
        tip: 'TODO');
  }
}
