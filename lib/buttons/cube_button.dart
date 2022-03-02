import 'package:cube_painter/buttons/hexagon_elevated_button.dart';
import 'package:cube_painter/colors.dart';
import 'package:cube_painter/cubes/full_unit_cube.dart';
import 'package:cube_painter/cubes/slice_unit_cube.dart';
import 'package:cube_painter/persisted/slice.dart';
import 'package:flutter/material.dart';

/// A button with a cube on it.
/// It can have an [Icon] too e.g. the plus sign for adding cubes.
/// The cube might be a whole cube or a slice of a cube.
class CubeButton extends StatelessWidget {
  final bool? isRadioOn;

  final void Function() onPressed;
  final IconData? icon;

  final double? iconSize;
  final String tip;

  final Slice slice;

  const CubeButton({
    Key? key,
    required this.onPressed,
    required this.tip,
    this.isRadioOn,
    this.icon,
    this.iconSize,
    this.slice = Slice.whole,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final offset =
        null != icon ? const Offset(1, 1) * iconSize! / 2 : Offset.zero;

    return ElevatedHexagonButton(
      isRadioOn: isRadioOn,
      child: Stack(
        children: [
          Transform.translate(
            offset: offset,
            child: Transform.scale(
              scale: 21,
              child: slice == Slice.whole
                  ? const WholeUnitCube()
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
