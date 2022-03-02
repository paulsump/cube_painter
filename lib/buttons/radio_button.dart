import 'package:cube_painter/buttons/elevated_hexagon_button.dart';
import 'package:cube_painter/buttons/thumbnail.dart';
import 'package:cube_painter/colors.dart';
import 'package:cube_painter/cubes/full_unit_cube.dart';
import 'package:cube_painter/cubes/slice_unit_cube.dart';
import 'package:cube_painter/persisted/cube_info.dart';
import 'package:cube_painter/persisted/position.dart';
import 'package:cube_painter/persisted/sketch.dart';
import 'package:cube_painter/persisted/slice.dart';
import 'package:cube_painter/transform/screen_size.dart';
import 'package:flutter/material.dart';

/// A raised hexagon shaped radio button
class RadioButton extends StatelessWidget {
  final VoidCallback onPressed;

  final String tip;
  final bool isRadioOn;

  final Widget child;

  const RadioButton({
    Key? key,
    required this.onPressed,
    required this.tip,
    required this.isRadioOn,
    required this.child,
  }) : super(key: key);

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
class CubesRadioButton extends StatelessWidget {
  final VoidCallback onPressed;

  final String tip;
  final bool isRadioOn;

  final IconData icon;
  final Slice slice;

  final bool isLine;

  const CubesRadioButton({
    Key? key,
    required this.onPressed,
    required this.tip,
    required this.icon,
    required this.isRadioOn,
    required this.slice,
    this.isLine = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const int n = 3;

    return RadioButton(
      isRadioOn: isRadioOn,
      child: _CubesAndIcon(
        icon: icon,
        cubes: isLine
            ? Transform.scale(
                scale: calcButtonChildScale(context) * 1.5,
                child: Thumbnail.useTransform(
                  sketch: Sketch(
                    cubeInfos: List.generate(
                      n,
                      (index) => CubeInfo(
                          center: Position(n - index, n - index),
                          slice: Slice.whole),
                    ),
                  ),
                ))
            : Transform.scale(
                scale: calcButtonChildScale(context),
                child: slice == Slice.whole
                    ? const WholeUnitCube()
                    : SliceUnitCube(slice: slice),
              ),
      ),
      onPressed: onPressed,
      tip: tip,
    );
  }
}

class _CubesAndIcon extends StatelessWidget {
  final IconData icon;

  final Widget cubes;

  const _CubesAndIcon({
    Key? key,
    required this.icon,
    required this.cubes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const unit = Offset(1, 1);

    return Stack(
      children: [
        Transform.translate(
          offset: unit * 12,
          child: cubes,
        ),
        Transform.translate(
          offset: -unit * calcAssetIconSize(context) / 2,
          child: Icon(icon, color: enabledIconColor),
        ),
      ],
    );
  }
}
