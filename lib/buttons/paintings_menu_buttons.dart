import 'package:cube_painter/buttons/hexagon_border.dart';
import 'package:cube_painter/buttons/hexagon_elevated_button.dart';
import 'package:cube_painter/colors.dart';
import 'package:cube_painter/constants.dart';
import 'package:flutter/material.dart';

/// Transparent icon button.
/// Used at the top of the [PaintingsMenu] (the file menu).
class FlatIconHexagonButton extends StatelessWidget {
  final String tip;
  final IconData icon;
  final double iconSize;
  final VoidCallback? onPressed;

  const FlatIconHexagonButton({
    Key? key,
    required this.tip,
    required this.icon,
    required this.iconSize,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tip,
      child: TextButton(
        child: Icon(
          icon,
          color: onPressed != null ? enabledIconColor : disabledIconColor,
          size: iconSize,
        ),
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

/// Pressing this button opens up the [Drawer] for the
/// [PaintingsMenu] (the file menu).
class OpenPaintingsMenuButton extends StatelessWidget {
  const OpenPaintingsMenuButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HexagonElevatedButton(
      child: Icon(
        Icons.folder_sharp,
        color: enabledIconColor,
        size: normalIconSize,
      ),
      onPressed: Scaffold.of(context).openDrawer,
      tip: 'Open the file menu.',
    );
  }
}
