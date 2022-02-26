import 'package:cube_painter/buttons/cube_button.dart';
import 'package:cube_painter/downloaded_icons.dart';
import 'package:cube_painter/gesture_mode.dart';
import 'package:flutter/material.dart';

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

    return CubeButton(
      radioOn: mode == gestureMode,
      icon: icon,
      iconSize: downloadedIconSize,
      onPressed: () => setGestureMode(mode, context),
      tip: tip,
    );
  }
}
