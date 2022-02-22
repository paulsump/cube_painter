import 'package:cube_painter/buttons/hexagon_button.dart';
import 'package:cube_painter/colors.dart';
import 'package:flutter/material.dart';

class TextItem {
  final String text;
  final String tip;
  final IconData icon;
  final VoidCallback callback;

  const TextItem({
    required this.text,
    required this.tip,
    required this.icon,
    required this.callback,
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
      // Container(      color: backgroundColor,
      height: 66,
      child: ListTile(
        trailing: HexagonButton(
          child: Icon(
            item.icon,
            color: enabledIconColor,
            size: iconSize,
          ),
          onPressed: () {
            item.callback();
            Navigator.pop(context);
          },
          tip: item.tip,
        ),
        title: Text(item.text),
        // onTap: () {
        //   item.callback();
        //   Navigator.pop(context);
        // },
      ),
    );
  }
}
