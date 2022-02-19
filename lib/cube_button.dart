import 'package:cube_painter/buttons/hexagon_button.dart';
import 'package:cube_painter/colors.dart';
import 'package:cube_painter/cubes/cube_sides.dart';
import 'package:cube_painter/cubes/full_unit_cube.dart';
import 'package:flutter/material.dart';

class CubeButton extends StatelessWidget {
  final bool? radioOn;
  final String tip;
  final void Function() onPressed;
  final IconData icon;

  const CubeButton({
    Key? key,
    this.radioOn,
    required this.onPressed,
    required this.icon,
    required this.tip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double iconSize = IconTheme.of(context).size!;
    // final gestureMode = getGestureMode(context, listen: true);
    return HexagonButton(
      radioOn: radioOn,
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
                icon,
                color: getColor(Side.br),
              ),
            ),
          ),
        ],
      ),
      onPressed: onPressed,
      tip: tip,
    );
  }
}
