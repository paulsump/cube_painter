import 'package:cube_painter/colors.dart';
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
            ListTile(
              leading: Icon(item.icon),
              title: Text(item.text),
              onTap: () {
                item.callback();
                Navigator.pop(context);
              },
            ),
        ],
      ),
    );
  }
}
