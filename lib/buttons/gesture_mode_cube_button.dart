import 'package:cube_painter/buttons/cube_button.dart';
import 'package:cube_painter/constants.dart';
import 'package:cube_painter/gesture_mode.dart';
import 'package:flutter/material.dart';

/// A radio button with a cube.
/// Used for setting [GestureMode].
class GestureModeCubeButton extends StatelessWidget {
  final GestureMode mode;

  final IconData icon;
  final String tip;

  const GestureModeCubeButton({
    Key? key,
    required this.mode,
    required this.icon,
    required this.tip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gestureMode = getGestureMode(context, listen: true);

    return CubeElevatedHexagonButton(
      isRadioOn: mode == gestureMode,
      icon: icon,
      iconSize: assetIconSize,
      onPressed: () => setGestureMode(mode, context),
      tip: tip,
    );
  }
}
