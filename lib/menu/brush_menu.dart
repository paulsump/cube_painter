import 'package:cube_painter/app_icons.dart';
import 'package:cube_painter/buttons/brush_menu_button.dart';
import 'package:cube_painter/buttons/cube_button.dart';
import 'package:cube_painter/buttons/hexagon_border.dart';
import 'package:cube_painter/buttons/hexagon_elevated_button.dart';
import 'package:cube_painter/colors.dart';
import 'package:cube_painter/cubes/cubes.dart';
import 'package:cube_painter/data/crop.dart';
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
  bool _more = false;

  @override
  Widget build(BuildContext context) {
    final gestureMode = getGestureMode(context, listen: true);

    final bool canUndo = widget.cubes.undoer.canUndo;
    final bool canRedo = widget.cubes.undoer.canRedo;

    const double w = 14;
    const pad = SizedBox(width: w);
    final borderSide = BorderSide(width: 1.0, color: buttonBorderColor);

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
                Tooltip(
                  message: 'Undo the last add or delete operation.',
                  child: TextButton(
                    child: SizedBox(
                      height: 60,
                      child: Icon(
                        Icons.undo_sharp,
                        color: canUndo ? enabledIconColor : disabledIconColor,
                        size: iconSize,
                      ),
                    ),
                    onPressed: canUndo ? widget.cubes.undoer.undo : null,
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        HexagonBorder(side: borderSide),
                      ),
                      overlayColor: MaterialStateColor.resolveWith(
                          (states) => buttonColor),
                    ),
                  ),
                ),
                pad,
                Tooltip(
                  message:
                      'Redo the last add or delete operation that was undone.',
                  child: TextButton(
                    child: SizedBox(
                      height: 60,
                      child: Icon(
                        Icons.redo_sharp,
                        color: canRedo ? enabledIconColor : disabledIconColor,
                        size: iconSize,
                      ),
                    ),
                    onPressed: canUndo ? widget.cubes.undoer.redo : null,
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        HexagonBorder(side: borderSide),
                      ),
                      overlayColor: MaterialStateColor.resolveWith(
                          (states) => buttonColor),
                    ),
                  ),
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
                onPressed: () {
                  setGestureMode(GestureMode.erase, context);
                },
                tip:
                    'Tap on a cube to delete it.  You can change the position while you have your finger down.',
              ),
              pad,
              const BrushMenuButton(crop: Crop.c),
              pad,
              HexagonElevatedButton(
                radioOn: GestureMode.panZoom == gestureMode,
                child: Icon(
                  Icons.zoom_in_sharp,
                  color: enabledIconColor,
                  size: iconSize,
                ),
                onPressed: () => setGestureMode(GestureMode.panZoom, context),
                tip: 'Pinch to zoom, drag to move around.',
              ),
            ],
          ),
          if (_more)
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    BrushMenuButton(crop: Crop.dr),
                    pad,
                    BrushMenuButton(crop: Crop.dl),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    BrushMenuButton(crop: Crop.r),
                    SizedBox(width: w * 7, child: Icon(plusOutline)),
                    // pad,
                    // BrushMenuButton(crop: Crop.c),
                    // pad,
                    BrushMenuButton(crop: Crop.l),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    BrushMenuButton(crop: Crop.ur),
                    pad,
                    BrushMenuButton(crop: Crop.ul),
                  ],
                ),
              ],
            ),

          const SizedBox(height: 3),
          Center(
              child: TextButton(
            child: Text(_more ? '...Less' : 'More...',
                style: TextStyle(color: textColor)),
            onPressed: () {
              _more = !_more;
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
