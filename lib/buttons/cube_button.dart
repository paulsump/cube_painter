import 'package:cube_painter/buttons/hexagon_elevated_button.dart';
import 'package:cube_painter/colors.dart';
import 'package:cube_painter/cubes/full_unit_cube.dart';
import 'package:cube_painter/cubes/slice_unit_cube.dart';
import 'package:cube_painter/data/slice.dart';
import 'package:flutter/material.dart';

class CubeButton extends StatelessWidget {
  final bool? radioOn;

  final void Function() onPressed;
  final IconData? icon;

  final double? iconSize;
  final String tip;

  final Slice slice;
  final double height;

  const CubeButton({
    Key? key,
    required this.onPressed,
    required this.tip,
    this.radioOn,
    this.icon,
    this.iconSize,
    this.slice = Slice.whole,
    this.height = 70,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final offset =
        null != icon ? const Offset(1, 1) * iconSize! / 2 : Offset.zero;

    return HexagonElevatedButton(
      height: height,
      radioOn: radioOn,
      child: Stack(
        children: [
          Transform.translate(
            offset: offset,
            child: Transform.scale(
              scale: 21,
              child: slice == Slice.whole
                  ? const FullUnitCube()
                  : SliceUnitCube(slice: slice),
            ),
          ),
          if (null != icon)
            Transform.translate(
              offset: -offset,
              child: Transform.scale(
                scale: 29 / iconSize!,
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
