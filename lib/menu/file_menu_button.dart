import 'package:cube_painter/buttons/hexagon_border.dart';
import 'package:cube_painter/colors.dart';
import 'package:cube_painter/downloaded_icons.dart';
import 'package:flutter/material.dart';

class MenuItem {
  final String tip;
  final IconData icon;
  final double iconSize;
  final VoidCallback onPressed;
  final bool enabled;

  const MenuItem({
    required this.tip,
    required this.icon,
    required this.iconSize,
    required this.onPressed,
    this.enabled = true,
  });
}

class FileMenuButton extends StatelessWidget {
  const FileMenuButton({
    Key? key,
    required this.item,
  }) : super(key: key);

  final MenuItem item;

  @override
  Widget build(BuildContext context) {
    final borderSide = BorderSide(width: 1.0, color: buttonBorderColor);

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
          shape: MaterialStateProperty.all(
            HexagonBorder(side: borderSide),
          ),
          overlayColor: MaterialStateColor.resolveWith((states) => buttonColor),
          fixedSize: MaterialStateProperty.all(pageButtonSize),
        ),
      ),
    );
  }
}
