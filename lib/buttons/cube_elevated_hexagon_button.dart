import 'package:cube_painter/buttons/elevated_hexagon_button.dart';
import 'package:cube_painter/colors.dart';
import 'package:cube_painter/constants.dart';
import 'package:cube_painter/cubes/full_unit_cube.dart';
import 'package:cube_painter/cubes/slice_unit_cube.dart';
import 'package:cube_painter/persisted/slice.dart';
import 'package:flutter/material.dart';

/// A raised hexagon shaped button with a cube on it.
/// It can act as a radio or a push button.
/// It can have an [Icon] too e.g. the plus sign for adding cubes.
/// The cube might be a whole cube or a slice of a cube.
class CubeElevatedHexagonButton extends StatelessWidget {
  final VoidCallback onPressed;

  final String tip;
  final bool? isRadioOn;

  final IconData? icon;
  final Slice slice;

  const CubeElevatedHexagonButton({
    Key? key,
    required this.onPressed,
    required this.tip,
    this.isRadioOn,
    this.icon,
    this.slice = Slice.whole,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedHexagonButton(
      isRadioOn: isRadioOn,
      child: _CubeAndIcon(slice: slice, icon: icon),
      onPressed: onPressed,
      tip: tip,
    );
  }
}

class _CubeAndIcon extends StatelessWidget {
  const _CubeAndIcon({
    Key? key,
    required this.slice,
    required this.icon,
  }) : super(key: key);

  final Slice slice;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    const double iconSize = assetIconSize;

    final offset =
        null != icon ? const Offset(1, 1) * iconSize / 2 : Offset.zero;

    return Stack(
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
              scale: 29 / iconSize,
              child: Icon(icon, color: enabledIconColor),
            ),
          ),
      ],
    );
  }
}
