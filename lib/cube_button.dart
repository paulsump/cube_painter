import 'package:cube_painter/buttons/hexagon_button.dart';
import 'package:cube_painter/colors.dart';
import 'package:cube_painter/cubes/crop_unit_cube.dart';
import 'package:cube_painter/cubes/cube_sides.dart';
import 'package:cube_painter/cubes/full_unit_cube.dart';
import 'package:cube_painter/data/crop.dart';
import 'package:flutter/material.dart';

class CubeButton extends StatelessWidget {
  final bool? radioOn;

  final void Function() onPressed;
  final IconData icon;

  final String tip;
  final Crop crop;

  const CubeButton({
    Key? key,
    this.radioOn,
    required this.onPressed,
    required this.icon,
    required this.tip,
    this.crop = Crop.c,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double iconSize = IconTheme.of(context).size!;

    return HexagonButton(
      radioOn: radioOn,
      child: Stack(
        children: [
          Transform.translate(
            offset: unit * iconSize / 2,
            child: Transform.scale(
              scale: 21,
              child: crop == Crop.c
                  ? const FullUnitCube()
                  : CropUnitCube(crop: crop),
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
