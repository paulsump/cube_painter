import 'package:cube_painter/colors.dart';
import 'package:cube_painter/cubes/cube_sides.dart';
import 'package:cube_painter/menu_button.dart';
import 'package:flutter/material.dart';

class MenuItem {
  final VoidCallback callback;
  final String text;
  final IconData icon;

  const MenuItem({
    required this.callback,
    required this.text,
    required this.icon,
  });
}

class Menu extends StatelessWidget {
  final List<MenuItem> items;
  final List<MenuButton> buttons;

  const Menu({Key? key, required this.items, required this.buttons})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: backgroundColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(height: 20.0),
            for (MenuItem item in items)
              Container(
                color: backgroundColor,
                child: ListTile(
                  leading: Icon(
                    item.icon,
                    color: getColor(Side.br),
                  ),
                  title: Text(item.text),
                  onTap: () {
                    item.callback();
                    Navigator.pop(context);
                  },
                ),
              ),
            Row(children: [
              for (MenuButton button in buttons) button,
              // Container(
              //   color: backgroundColor,
              //   child: ListTile(
              //     leading: button,
              //     title: const Text('Cube Type'),
              //   ),
              // ),
            ]),
          ],
        ),
      ),
    );
  }
}
