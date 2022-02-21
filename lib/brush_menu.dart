import 'package:cube_painter/cubes/thumbnail.dart';
import 'package:cube_painter/data/crop.dart';
import 'package:cube_painter/data/cube_group.dart';
import 'package:cube_painter/menu_button.dart';
import 'package:cube_painter/menu_text_item.dart';
import 'package:cube_painter/out.dart';
import 'package:flutter/material.dart';

const noWarn = out;

class BrushMenu extends StatelessWidget {
  const BrushMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubeGroupNotifier = getCubeGroupNotifier(context);

    final items = <TextItem>[
      TextItem(
        text: 'Load',
        icon: Icons.file_open_sharp,
        callback: cubeGroupNotifier.load,
      ),
      TextItem(
        text: 'Save',
        icon: Icons.save,
        callback: cubeGroupNotifier.save,
      ),
      TextItem(
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
          MenuTextItem(
              item: TextItem(
            text: 'New',
            icon: Icons.star,
            // TODO create new persisted file,
            // so as not to overwrite the current one
            callback: cubeGroupNotifier.clear,
          )),
          const Center(child: Text('Save Current:')),
          Thumbnail(cubeGroup: cubeGroupNotifier.cubeGroup),
          const Center(child: Text('Load from:')),
          Thumbnail(cubeGroup: cubeGroupNotifier.cubeGroup),
          for (TextItem item in items) MenuTextItem(item: item),
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
