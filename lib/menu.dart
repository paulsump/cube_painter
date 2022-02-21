import 'package:cube_painter/buttons/hexagon_button.dart';
import 'package:cube_painter/colors.dart';
import 'package:cube_painter/cubes/cube_sides.dart';
import 'package:cube_painter/data/crop.dart';
import 'package:cube_painter/data/cube_group.dart';
import 'package:cube_painter/menu_button.dart';
import 'package:cube_painter/out.dart';
import 'package:flutter/material.dart';

const noWarn = out;

class Menu extends StatelessWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubeGroupNotifier = getCubeGroupNotifier(context);

    final items = <_Item>[
      _Item(
        text: 'New',
        icon: Icons.star,
        // TODO create new persisted file,
        // so as not to overwrite the current one
        callback: cubeGroupNotifier.clear,
      ),
      _Item(
        text: 'Load',
        icon: Icons.file_open_sharp,
        callback: cubeGroupNotifier.load,
      ),
      _Item(
        text: 'Save',
        icon: Icons.save,
        callback: cubeGroupNotifier.save,
      ),
      _Item(
        text: 'Next Example',
        icon: Icons.forward,
        callback: cubeGroupNotifier.loadNextExample,
      ),
    ];

    const margin = 23;
    const x0 = 39 + margin;
    const double x1 = 12;
    const xm = 4 + margin;
    const double x2 = 9;

    return Drawer(
      // child: Container(
      // color: backgroundColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(height: 10.0 + MediaQuery.of(context).padding.top),
          for (_Item item in items)
            SizedBox(
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
            ),
          const Divider(),
          const Center(child: Text('Painting Modes')),
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
        ],
      ),
    );
  }
}

class _Item {
  final VoidCallback callback;
  final String text;
  final IconData icon;

  const _Item({
    required this.callback,
    required this.text,
    required this.icon,
  });
}
