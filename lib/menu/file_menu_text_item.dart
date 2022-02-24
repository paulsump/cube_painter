import 'package:cube_painter/colors.dart';
import 'package:flutter/material.dart';

class TextItem {
  final String title;
  final String tip;
  final IconData icon;
  final double iconSize;
  final VoidCallback callback;
  final bool enabled;

  const TextItem({
    required this.title,
    required this.tip,
    required this.icon,
    required this.iconSize,
    required this.callback,
    this.enabled = true,
  });
}

class FileMenuTextItem extends StatelessWidget {
  const FileMenuTextItem({
    Key? key,
    required this.item,
  }) : super(key: key);

  final TextItem item;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 66,
      child: ListTile(
        trailing: Tooltip(
          message: item.tip,
          child: IconButton(
            icon: Icon(
              item.icon,
              color: item.enabled ? enabledIconColor : disabledIconColor,
              size: item.iconSize,
            ),
            onPressed: item.enabled ? item.callback : null,
          ),
        ),
        title: Text(item.title),
      ),
    );
  }
}
