import 'package:cube_painter/buttons/hexagon_button.dart';
import 'package:cube_painter/colors.dart';
import 'package:flutter/material.dart';

class TextItem {
  final String text;
  final String tip;
  final IconData icon;
  final VoidCallback callback;
  final bool enabled;

  const TextItem({
    required this.text,
    required this.tip,
    required this.icon,
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
        trailing: HexagonButton(
          child: Icon(
            item.icon,
            color: item.enabled ? enabledIconColor : disabledIconColor,
            size: iconSize,
          ),
          onPressed: item.enabled ? item.callback : null,
          tip: item.tip,
        ),
        title: Text(item.text),
      ),
    );
  }
}
