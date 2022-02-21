import 'package:cube_painter/buttons/hexagon_button.dart';
import 'package:cube_painter/colors.dart';
import 'package:cube_painter/cubes/cube_sides.dart';
import 'package:flutter/material.dart';

class TextItem {
  final VoidCallback callback;
  final String text;
  final IconData icon;

  const TextItem({
    required this.callback,
    required this.text,
    required this.icon,
  });
}

class MenuTextItem extends StatelessWidget {
  const MenuTextItem({
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
        leading: HexagonButton(
          child: Icon(
            item.icon,
            color: getColor(Side.br),
          ),
          onPressed: () {
            item.callback();
            Navigator.pop(context);
          },
          tip: 'Undo the last add or delete operation.',
        ),
        title: Text(item.text),
        onTap: () {
          item.callback();
          Navigator.pop(context);
        },
      ),
    );
  }
}
