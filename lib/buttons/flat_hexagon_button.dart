// Copyright (c) 2022, Paul Sumpner.  All rights reserved.

import 'package:cube_painter/buttons/hexagon_border.dart';
import 'package:cube_painter/hue.dart';
import 'package:cube_painter/transform/screen_size.dart';
import 'package:flutter/material.dart';

/// Transparent flat hexagon shaped [TextButton] (without text).
class FlatHexagonButton extends StatelessWidget {
  const FlatHexagonButton({
    Key? key,
    this.onPressed,
    required this.tip,
    required this.child,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final String tip;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screenAdjustButtonWidth(context),
      child: Tooltip(
        message: tip,
        child: TextButton(
          child: child,
          onPressed: onPressed,
          style: ButtonStyle(
            shape: hexagonBorderShape,
            fixedSize:
            MaterialStateProperty.all(screenAdjustButtonSize(context)),
            backgroundColor:
            MaterialStateProperty.all(Hue.paintingsMenuButtons),
            overlayColor:
            MaterialStateColor.resolveWith((states) => Hue.button),
          ),
        ),
      ),
    );
  }
}

/// A [FlatHexagonButton] with an icon.
class IconFlatHexagonButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String tip;
  final IconData icon;
  final double iconSize;

  const IconFlatHexagonButton({
    Key? key,
    this.onPressed,
    required this.tip,
    required this.icon,
    required this.iconSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatHexagonButton(
      onPressed: onPressed,
      tip: tip,
      child: Icon(
        icon,
        color: onPressed != null ? Hue.enabledIcon : Hue.disabledIcon,
        size: iconSize,
      ),
    );
  }
}
