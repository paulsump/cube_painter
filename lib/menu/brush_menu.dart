import 'package:cube_painter/app_icons.dart';
import 'package:cube_painter/buttons/crop_cube_button.dart';
import 'package:cube_painter/buttons/cube_button.dart';
import 'package:cube_painter/buttons/hexagon_border_button.dart';
import 'package:cube_painter/buttons/hexagon_elevated_button.dart';
import 'package:cube_painter/colors.dart';
import 'package:cube_painter/cubes/cubes.dart';
import 'package:cube_painter/data/crop.dart';
import 'package:cube_painter/data/cube_group.dart';
import 'package:cube_painter/gesture_mode.dart';
import 'package:cube_painter/out.dart';
import 'package:flutter/material.dart';

const noWarn = out;

class BrushMenu extends StatefulWidget {
  final Cubes cubes;

  const BrushMenu({Key? key, required this.cubes}) : super(key: key);

  @override
  State<BrushMenu> createState() => _BrushMenuState();
}

class _BrushMenuState extends State<BrushMenu> {
  bool get showCrops => getCubeGroupNotifier(context).showCrops;

  @override
  Widget build(BuildContext context) {
    final gestureMode = getGestureMode(context, listen: true);

    final bool canUndo = widget.cubes.undoer.canUndo;
    final bool canRedo = widget.cubes.undoer.canRedo;

    const double w = 14;
    const pad = SizedBox(width: w);

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
                HexagonBorderButton(
                  tip: 'Undo the last add or delete operation.',
                  child: SizedBox(
                    height: 60,
                    child: Icon(
                      Icons.undo_sharp,
                      color: canUndo ? enabledIconColor : disabledIconColor,
                      size: iconSize,
                    ),
                  ),
                  onPressed: canUndo ? widget.cubes.undoer.undo : null,
                ),
                pad,
                HexagonBorderButton(
                  tip: 'Redo the last add or delete operation that was undone.',
                  child: SizedBox(
                    height: 60,
                    child: Icon(
                      Icons.redo_sharp,
                      color: canRedo ? enabledIconColor : disabledIconColor,
                      size: iconSize,
                    ),
                  ),
                  onPressed: canRedo ? widget.cubes.undoer.redo : null,
                ),
              ],
            ),
          ),
          // const Divider(),
          // const SizedBox(height: 22),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CubeButton(
                radioOn: GestureMode.erase == gestureMode,
                icon: cancelOutline,
                iconSize: appIconSize,
                onPressed: () {
                  setGestureMode(GestureMode.erase, context);
                },
                tip:
                    'Tap on a cube to delete it.  You can change the position while you have your finger down.',
              ),
              pad,
              CubeButton(
                radioOn: GestureMode.add == gestureMode,
                icon: plusOutline,
                iconSize: appIconSize,
                onPressed: () {
                  setGestureMode(GestureMode.add, context);
                  setCrop(Crop.c, context);
                },
                tip:
                    'Tap or drag on the canvas to add a row of cubes. You can change the direction while you drag.',
              ),
              pad,
              HexagonElevatedButton(
                radioOn: GestureMode.panZoom == gestureMode,
                child: Icon(
                  Icons.zoom_in_sharp,
                  size: iconSize * 1.2,
                  color: enabledIconColor,
                ),
                onPressed: () => setGestureMode(GestureMode.panZoom, context),
                tip: 'Pinch to zoom, drag to move around.',
              ),
            ],
          ),
          if (showCrops)
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CropCubeButton(crop: Crop.dr),
                    pad,
                    CropCubeButton(crop: Crop.dl),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CropCubeButton(crop: Crop.r),
                    SizedBox(width: w * 7, child: Icon(plusOutline)),
                    // pad,
                    // BrushMenuButton(crop: Crop.c),
                    // pad,
                    CropCubeButton(crop: Crop.l),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CropCubeButton(crop: Crop.ur),
                    pad,
                    CropCubeButton(crop: Crop.ul),
                  ],
                ),
              ],
            ),

          const SizedBox(height: 3),
          Center(
              child: TextButton(
                child: Text(showCrops ? '...Less' : 'More...',
                style: TextStyle(color: textColor)),
            onPressed: () {
              final cubeGroupNotifier = getCubeGroupNotifier(context);
              cubeGroupNotifier.saveShowCrops(!showCrops);
              setState(() {});
            },
          )),
          const Divider(),
          const SizedBox(height: 22),
        ],
      ),
    );
  }
}
