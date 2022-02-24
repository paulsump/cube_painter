import 'package:cube_painter/colors.dart';
import 'package:flutter/material.dart';

class TextItem {
  final String tip;
  final IconData icon;
  final double iconSize;
  final VoidCallback callback;
  final bool enabled;

  const TextItem({
    required this.tip,
    required this.icon,
    required this.iconSize,
    required this.callback,
    this.enabled = true,
  });
}


class FileMenuButton extends StatelessWidget {
  const FileMenuButton({
    Key? key,
    required this.item,
  }) : super(key: key);

  final TextItem item;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: item.tip,
      child: IconButton(
        icon: Icon(
          item.icon,
          color: item.enabled ? enabledIconColor : disabledIconColor,
          size: item.iconSize,
        ),
        onPressed: item.enabled ? item.callback : null,
      ),
    );
  }
}
