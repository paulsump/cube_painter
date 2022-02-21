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

    //TODO Remove
    const margin = 0;
    const x0 = 0 + margin;
    const double x1 = 0;
    const xm = 0 + margin;
    const double x2 = 0;
    const eraseAndPanZoomOffsetX = Offset(0, 0);
    const pad = SizedBox(width: 14);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(height: 10.0 + MediaQuery.of(context).padding.top),
          Transform.translate(
            // offset:  Offset(constraints.maxWidth/2,0),
            offset: Offset.zero,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HexagonButton(
                  child: Icon(Icons.undo_sharp,
                      color: getColor(
                        canUndo ? Side.br : Side.bl,
                      )),
                  onPressed: canUndo ? undo : null,
                  tip: 'Undo the last add or delete operation.',
                ),
                pad,
                HexagonButton(
                  child: Icon(Icons.redo_sharp,
                      color: getColor(
                        canRedo ? Side.br : Side.bl,
                      )),
                  onPressed: canRedo ? redo : null,
                  tip: 'Redo the last add or delete operation that was undone.',
                ),
              ],
            ),
          ),
          const Divider(),
          const Center(child: Text('Brushes')),
          const SizedBox(height: 22),
          Transform.translate(
            offset: eraseAndPanZoomOffsetX,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              BrushMenuButton(crop: Crop.dr, offsetX: x0 + x1 * 1),
              pad,
              BrushMenuButton(crop: Crop.dl, offsetX: x0 + x1 * 2),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              BrushMenuButton(crop: Crop.r, offsetX: xm + x2 * 1),
              pad,
              BrushMenuButton(crop: Crop.c, offsetX: xm + x2 * 2),
              pad,
              BrushMenuButton(crop: Crop.l, offsetX: xm + x2 * 3),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              BrushMenuButton(crop: Crop.ur, offsetX: x0 + x1 * 1),
              pad,
              BrushMenuButton(crop: Crop.ul, offsetX: x0 + x1 * 2),
            ],
          ),
          Transform.translate(
            offset: eraseAndPanZoomOffsetX,
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
