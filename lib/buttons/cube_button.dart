import 'package:cube_painter/buttons/hexagon_elevated_button.dart';
import 'package:cube_painter/colors.dart';
import 'package:cube_painter/cubes/crop_unit_cube.dart';
import 'package:cube_painter/cubes/cube_sides.dart';
import 'package:cube_painter/cubes/full_unit_cube.dart';
import 'package:cube_painter/data/crop.dart';
import 'package:flutter/material.dart';

class CubeButton extends StatelessWidget {
  final bool? radioOn;

  final void Function() onPressed;
  final IconData? icon;

  final String tip;
  final Crop crop;

  final double height;

  const CubeButton({
    Key? key,
    required this.onPressed,
    required this.tip,
    this.radioOn,
    this.icon,
    this.crop = Crop.c,
    this.height = 70,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double iconSize = IconTheme.of(context).size!;

    return HexagonElevatedButton(
      height: height,
      radioOn: radioOn,
      child: Stack(
        children: [
          Transform.translate(
            offset: null != icon ? unit * iconSize / 2 : Offset.zero,
            child: Transform.scale(
              scale: 21,
              child: crop == Crop.c
                  ? const FullUnitCube()
                  : CropUnitCube(crop: crop),
            ),
          ),
          if (null != icon)
            Transform.translate(
              offset: unit * -iconSize / 2,
              child: Transform.scale(
                scale: 29 / iconSize,
                child: Icon(
                  icon,
                  color: enabledIconColor,
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
