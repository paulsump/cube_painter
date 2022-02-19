import 'package:cube_painter/colors.dart';
import 'package:cube_painter/cube_button.dart';
import 'package:cube_painter/cubes/cube_sides.dart';
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
  final List<CubeButton> brushs;

  const Menu({Key? key, required this.items, required this.brushs})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: backgroundColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: backgroundColor,
              ),
              child: const Text('Options'),
            ),
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
            for (CubeButton brush in brushs)
              Container(
                color: backgroundColor,
                child: ListTile(
                  leading: brush,
                  title: const Text('Crop'),
                  onTap: () {
                    // item.callback();
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
