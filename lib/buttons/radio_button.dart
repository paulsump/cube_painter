// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'package:cube_painter/buttons/elevated_hexagon_button.dart';
import 'package:cube_painter/buttons/thumbnail.dart';
import 'package:cube_painter/cubes/slice_unit_cube.dart';
import 'package:cube_painter/cubes/whole_unit_cube.dart';
import 'package:cube_painter/hue.dart';
import 'package:cube_painter/persisted/cube_info.dart';
import 'package:cube_painter/persisted/painting.dart';
import 'package:cube_painter/persisted/position.dart';
import 'package:cube_painter/persisted/slice.dart';
import 'package:cube_painter/transform/screen_adjust.dart';
import 'package:flutter/material.dart';

const _unitOffset = Offset(1, 1);

/// A raised hexagon shaped radio button
class RadioButton extends StatelessWidget {
  const RadioButton({
    Key? key,
    required this.onPressed,
    required this.tip,
    required this.isRadioOn,
    required this.child,
  }) : super(key: key);

  final VoidCallback onPressed;
  final String tip;

  final bool isRadioOn;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ElevatedHexagonButton(
      isRadioOn: isRadioOn,
      child: child,
      onPressed: onPressed,
      tip: tip,
    );
  }
}

/// A raised hexagon shaped radio button with a cube on it.
/// It has an [Icon] e.g. the plus sign for adding cubes.
/// The cube might be a whole cube or a slice of a cube,
/// dictated by [Slice].
class CubeRadioButton extends StatelessWidget {
  const CubeRadioButton({
    Key? key,
    required this.onPressed,
    required this.tip,
    required this.icon,
    required this.iconSize,
    required this.isRadioOn,
    required this.slice,
  }) : super(key: key);

  final VoidCallback onPressed;
  final String tip;

  final bool isRadioOn;
  final IconData icon;

  final double iconSize;
  final Slice slice;

  @override
  Widget build(BuildContext context) {
    return RadioButton(
      isRadioOn: isRadioOn,
      child: _ChildAndIcon(
        child: Transform.scale(
          scale: screenAdjustButtonChildScale(context),
          child: slice == Slice.whole
              ? const WholeUnitCube()
              : SliceUnitCube(slice: slice),
        ),
        icon: icon,
        iconSize: iconSize,
      ),
      onPressed: onPressed,
      tip: tip,
    );
  }
}

/// A raised hexagon shaped radio button with a line of cubes on it.
/// It has an [Icon] - the plus sign for adding lines of cubes.
class CubeLineRadioButton extends StatelessWidget {
  const CubeLineRadioButton({
    Key? key,
    required this.onPressed,
    required this.tip,
    required this.icon,
    required this.iconSize,
    required this.isRadioOn,
    required this.wire,
    required this.diagonalOffset,
  }) : super(key: key);

  final VoidCallback onPressed;
  final String tip;

  final IconData icon;
  final double iconSize;

  final bool isRadioOn;
  final bool wire;

  final double diagonalOffset;

  @override
  Widget build(BuildContext context) {
    const int n = 3;

    return RadioButton(
      isRadioOn: isRadioOn,
      child: Transform.translate(
        offset: _unitOffset * screenAdjust(diagonalOffset, context),
        child: _ChildAndIcon(
            icon: icon,
            iconSize: iconSize,
            child: Transform.scale(
                scale: screenAdjustButtonChildScale(context) * 1.5,
                child: Thumbnail.useTransform(
                  painting: Painting(
                      cubeInfos: List.generate(
                          n,
                              (i) => CubeInfo(
                            center: Position(n - i, n - i),
                            slice: Slice.whole,
                          ))),
                  wire: wire,
                ))),
      ),
      onPressed: onPressed,
      tip: tip,
    );
  }
}

/// A [Stack] of the child (a cube) with an [Icon] on top.
class _ChildAndIcon extends StatelessWidget {
  const _ChildAndIcon({
    Key? key,
    required this.child,
    required this.icon,
    required this.iconSize,
  }) : super(key: key);

  final Widget child;
  final IconData icon;

  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Transform.translate(
          offset: _unitOffset * 10,
          child: child,
        ),
        Transform.translate(
          offset: -_unitOffset * screenAdjustAssetIconSize(context) / 2,
          child: Icon(
            icon,
            color: Hue.enabledIcon,
            size: iconSize,
          ),
        ),
      ],
    );
  }
}
