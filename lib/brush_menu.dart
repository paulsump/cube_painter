import 'package:cube_painter/brush_menu_button.dart';
import 'package:cube_painter/buttons/hexagon_button.dart';
import 'package:cube_painter/colors.dart';
import 'package:cube_painter/cube_button.dart';
import 'package:cube_painter/cubes/cube_sides.dart';
import 'package:cube_painter/cubes/cubes.dart';
import 'package:cube_painter/data/crop.dart';
import 'package:cube_painter/gesture_mode.dart';
import 'package:cube_painter/out.dart';
import 'package:flutter/material.dart';

const noWarn = out;

class BrushMenu extends StatelessWidget {
  final Cubes cubes;

  const BrushMenu({Key? key, required this.cubes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gestureMode = getGestureMode(context, listen: true);

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
    const double offsetX = -5;
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
          const Center(child: Text('Brushes')),
          const SizedBox(height: 22),
          Transform.translate(
            offset: Offset(offsetX, 0),
            child: CubeButton(
              radioOn: GestureMode.erase == gestureMode,
              icon: Icons.remove,
              onPressed: () {
                setGestureMode(GestureMode.erase, context);
              },
              tip:
                  'Tap on a cube to delete it.  You can change the position while you have your finger down.',
            ),
          ),
          Row(children: const [
            BrushMenuButton(crop: Crop.dr, offsetX: x0 + x1 * 1),
            BrushMenuButton(crop: Crop.dl, offsetX: x0 + x1 * 2),
          ]),
          Row(children: const [
            BrushMenuButton(crop: Crop.r, offsetX: xm + x2 * 1),
            BrushMenuButton(crop: Crop.c, offsetX: xm + x2 * 2),
            BrushMenuButton(crop: Crop.l, offsetX: xm + x2 * 3),
          ]),
          Row(children: const [
            BrushMenuButton(crop: Crop.ur, offsetX: x0 + x1 * 1),
            BrushMenuButton(crop: Crop.ul, offsetX: x0 + x1 * 2),
          ]),
          Transform.translate(
            offset: Offset(offsetX, 0),
            child: HexagonButton(
              radioOn: GestureMode.panZoom == gestureMode,
              child: const Icon(Icons.zoom_in_sharp),
              onPressed: () {
                setGestureMode(GestureMode.panZoom, context);
              },
              tip: 'Pinch to zoom, drag to move around.',
            ),
          ),
          const SizedBox(height: 3),
          const Center(child: Text('Pan / Zoom')),
          const Divider(),
          const SizedBox(height: 22),
        ],
      ),
    );
  }
}
