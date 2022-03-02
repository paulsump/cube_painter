import 'package:cube_painter/buttons/hexagon_border.dart';
import 'package:cube_painter/colors.dart';
import 'package:cube_painter/constants.dart';
import 'package:flutter/material.dart';

/// Transparent flat hexagon shaped button.
class FlatHexagonButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String tip;
  final Widget child;

  const FlatHexagonButton({
    Key? key,
    this.onPressed,
    required this.tip,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tip,
      child: TextButton(
        child: child,
        onPressed: onPressed,
        style: ButtonStyle(
          shape: hexagonBorderShape,
          fixedSize: MaterialStateProperty.all(pageButtonSize),
          backgroundColor: MaterialStateProperty.all(paintingsMenuButtonsColor),
          overlayColor: MaterialStateColor.resolveWith((states) => buttonColor),
        ),
      ),
    );
  }
}

/// Transparent flat hexagon shaped button with an icon.
/// A convenience for use at the top of the [PaintingsMenu] (the file menu).
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
    return Tooltip(
      message: tip,
      child: FlatHexagonButton(
        onPressed: onPressed,
        tip: tip,
        child: Icon(
          icon,
          color: onPressed != null ? enabledIconColor : disabledIconColor,
          size: iconSize,
        ),
      ),
    );
  }
}
