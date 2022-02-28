import 'package:cube_painter/buttons/hexagon_border.dart';
import 'package:cube_painter/buttons/hexagon_elevated_button.dart';
import 'package:cube_painter/colors.dart';
import 'package:cube_painter/constants.dart';
import 'package:flutter/material.dart';

/// Params for constructing [FlatIconHexagonButton]s
class PaintingsMenuItem {
  final String tip;
  final IconData icon;
  final double iconSize;
  final VoidCallback onPressed;
  final bool enabled;

  const PaintingsMenuItem({
    required this.tip,
    required this.icon,
    required this.iconSize,
    required this.onPressed,
    this.enabled = true,
  });
}

/// the little icon buttons at the top of the [PaintingsMenu] (the file menu).
class FlatIconHexagonButton extends StatelessWidget {
  final PaintingsMenuItem item;

  const FlatIconHexagonButton({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: item.tip,
      child: TextButton(
        child: Icon(
          item.icon,
          color: item.enabled ? enabledIconColor : disabledIconColor,
          size: item.iconSize,
        ),
        onPressed: item.enabled ? item.onPressed : null,
        style: ButtonStyle(
          shape: hexagonBorderShape,
          overlayColor: MaterialStateColor.resolveWith((states) => buttonColor),
          fixedSize: MaterialStateProperty.all(pageButtonSize),
          backgroundColor: MaterialStateProperty.all(paintingsMenuButtonsColor),
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
