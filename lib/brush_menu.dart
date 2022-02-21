import 'package:cube_painter/buttons/hexagon_button.dart';
import 'package:cube_painter/colors.dart';
import 'package:cube_painter/cubes/cube_sides.dart';
import 'package:cube_painter/cubes/cubes.dart';
import 'package:cube_painter/data/crop.dart';
import 'package:cube_painter/data/cube_group.dart';
import 'package:cube_painter/menu_button.dart';
import 'package:cube_painter/out.dart';
import 'package:flutter/material.dart';

const noWarn = out;

class BrushMenu extends StatelessWidget {
  final Cubes cubes;

  const BrushMenu({Key? key, required this.cubes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubeGroupNotifier = getCubeGroupNotifier(context);

    final bool canUndo = cubes.undoer.canUndo;
    final bool canRedo = cubes.undoer.canRedo;

    void undo() {
      if (canUndo) {
        cubes.undoer.undo();
        // Navigator.pop(context);
      }
    }

    void redo() {
      if (canRedo) {
        cubes.undoer.redo();
        // Navigator.pop(context);
      }
    }

    const margin = 23;
    const x0 = 39 + margin;
    const double x1 = 12;
    const xm = 4 + margin;
    const double x2 = 9;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(height: 10.0 + MediaQuery.of(context).padding.top),
          ListTile(
            leading: HexagonButton(
              child: Icon(Icons.undo_sharp,
                  color: getColor(
                    canUndo ? Side.br : Side.bl,
                  )),
              onPressed: canUndo ? undo : null,
              tip: 'Undo the last add or delete operation.',
            ),
            title: const Text('Undo'),
            onTap: undo,
          ),
          ListTile(
            leading: HexagonButton(
              child: Icon(Icons.redo_sharp,
                  color: getColor(
                    canRedo ? Side.br : Side.bl,
                  )),
              onPressed: canRedo ? redo : null,
              tip: 'Redo the last add or delete operation that was undone.',
            ),
            title: const Text('Redo'),
            onTap: redo,
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
