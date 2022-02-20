import 'package:cube_painter/buttons/hexagon_button.dart';
import 'package:cube_painter/colors.dart';
import 'package:cube_painter/cubes/cube_sides.dart';
import 'package:cube_painter/cubes/cubes.dart';
import 'package:cube_painter/data/crop.dart';
import 'package:cube_painter/data/cube_group.dart';
import 'package:cube_painter/menu_button.dart';
import 'package:cube_painter/out.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
        callback: cubeGroupNotifier.clear,
      ),
      _Item(
        text: 'Load Next',
        icon: Icons.forward,
        callback: cubeGroupNotifier.loadNext,
      ),
      _Item(
        text: 'Save to Clipboard',
        icon: Icons.save_alt_sharp,
        callback: () =>
            Clipboard.setData(ClipboardData(text: cubeGroupNotifier.json)),
      ),
    ];

    const margin = 23;
    const x0 = 39 + margin;
    const double x1 = 12;
    const xm = 4 + margin;
    const double x2 = 9;

    return Drawer(
      child: Container(
        color: backgroundColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(height: 40.0),
            for (_Item item in items)
              Container(
                color: backgroundColor,
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
