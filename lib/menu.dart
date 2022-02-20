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
    const x0 = 39;
    const double x1 = 12;
    const xm = 4;
    const double x2 = 9;

    return Drawer(
      child: Container(
        color: backgroundColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(height: -10.0 + MediaQuery.of(context).padding.top),
            const Center(child: Text('Slice Mode')),
            const SizedBox(height: 22),
            Row(children: const [
              MenuButton(crop: Crop.dr, offsetX: x0 + x1 * 1),
              MenuButton(crop: Crop.dl, offsetX: x0 + x1 * 2),
            ]),
            Row(children: const [
              MenuButton(crop: Crop.r, offsetX: xm + x2 * 1),
              MenuButton(crop: Crop.c, offsetX: xm + x2 * 2),
              MenuButton(crop: Crop.l, offsetX: xm + x2 * 3),
            ]),
            Row(children: const [
              MenuButton(crop: Crop.ur, offsetX: x0 + x1 * 1),
              MenuButton(crop: Crop.ul, offsetX: x0 + x1 * 2),
            ]),
            const SizedBox(height: 22),
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
          ],
        ),
      ),
    );
  }
}
