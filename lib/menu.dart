import 'package:cube_painter/colors.dart';
import 'package:cube_painter/cubes/cube_sides.dart';
import 'package:cube_painter/data/crop.dart';
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

  const Menu({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: backgroundColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // const SizedBox(height: 20.0),
            const Divider(),
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
            const Divider(),
            const Center(child: Text('Cube Types')),
            const Divider(),
            Row(children: const [
              MenuButton(crop: Crop.dr, offsetX: 3),
              MenuButton(crop: Crop.dl, offsetX: 3),
            ]),
            Row(children: const [
              MenuButton(crop: Crop.r, offsetX: 3),
              MenuButton(crop: Crop.c, offsetX: 3),
              MenuButton(crop: Crop.l, offsetX: 3),
            ]),
            Row(children: const [
              MenuButton(crop: Crop.ur, offsetX: 3),
              MenuButton(crop: Crop.ul, offsetX: 3),
            ]),
          ],
        ),
      ),
    );
  }
}
