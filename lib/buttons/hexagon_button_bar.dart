import 'package:cube_painter/buttons/hexagon.dart';
import 'package:cube_painter/buttons/hexagon_button.dart';
import 'package:cube_painter/colors.dart';
import 'package:cube_painter/cubes/crop_unit_cube.dart';
import 'package:cube_painter/cubes/full_unit_cube.dart';
import 'package:cube_painter/data/crop.dart';
import 'package:cube_painter/data/cube_group.dart';
import 'package:cube_painter/gesture_mode.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/transform/position_to_unit.dart';
import 'package:cube_painter/undoer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const noWarn = out;

class HexagonButtonBar extends StatelessWidget {
  final Undoer undoer;

  final VoidCallback saveToClipboard;

  final void Function(String message) showTip;
  final VoidCallback hideTip;

  final double height;

  const HexagonButtonBar({
    Key? key,
    required this.undoer,
    required this.saveToClipboard,
    required this.showTip,
    required this.hideTip,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Crop crop = Provider.of<CropNotifier>(context, listen: true).crop;

    final gestureModeButtonInfo = [
      [],
      [
        Icons.add,
        const FullUnitCube(),
            () => showTip(
            'Tap or drag on the canvas to add a row of cubes. You can change the direction while you drag.'),
      ],
      [
        Icons.remove,
        const FullUnitCube(),
            () => showTip(
            'Tap on a cube to delete it.  You can change the position while you have your finger down.'),
      ],
      [
        Icons.add,
        CropUnitCube(crop: crop),
            () => showTip(
            'Tap to add half a cube.  Cycle through the six options by pressing this button again.  You can change the position while you have your finger down.'),
      ],
    ];

    final otherButtonInfo = [
      [
        undoer.canUndo,
        Icons.undo_sharp,
        undoer.undo,
        () => showTip('Undo the last add or delete operation.'),
      ],
      [
        undoer.canRedo,
        Icons.redo_sharp,
        undoer.redo,
        () => showTip('Redo the last add or delete operation that was undone.'),
      ],
      [
        true,
        Icons.forward,
        () => getCubeGroupNotifier(context).increment(1),
        () => showTip('Load next group of cubes.'),
      ],
      [
        true,
        Icons.save_alt_sharp,
        saveToClipboard,
        () => showTip('Save the current group of cubes to the clipboard.'),
      ],
    ];

    final int n = gestureModeButtonInfo.length + otherButtonInfo.length;
    final double radius = height / 2;

    final double x = 2 * radius * W;
    final double y = 2 * radius * H;

    return Stack(
      children: [
        HexagonButton(
          icon: Icons.zoom_in_rounded,
          gestureMode: GestureMode.panZoom,
          center: Offset(x * 0.5, y),
          radius: radius,
          showTip: () =>
              showTip('Pinch to zoom in/out or drag to move the canvas'),
          hideTip: hideTip,
        ),
        for (int i = 1; i < gestureModeButtonInfo.length; ++i)
          HexagonButton(
            icon: gestureModeButtonInfo[i][0] as IconData,
            iconOffset: const Offset(W, H) * -radius * 0.5,
            unitChild: gestureModeButtonInfo[i][1] as Widget,
            gestureMode: GestureMode.values[i],
            center: Offset(x * (i + 0.5), y),
            radius: radius,
            onPressed: i == 3
                ? () {
                    final cropNotifier =
                        Provider.of<CropNotifier>(context, listen: false);
                    cropNotifier.increment(-1);
                  }
                : null,
            showTip: gestureModeButtonInfo[i][2] as VoidCallback,
            hideTip: hideTip,
          ),
        for (int i = 0; i < otherButtonInfo.length; ++i)
          HexagonButton(
            enabled: otherButtonInfo[i][0] as bool,
            icon: otherButtonInfo[i][1] as IconData,
            onPressed: otherButtonInfo[i][2] as VoidCallback,
            center: Offset(x * (i + 4.5), y),
            radius: radius,
            showTip: otherButtonInfo[i][3] as VoidCallback,
            hideTip: hideTip,
          ),
        for (int i = 0; i < 1 + n; ++i)
          Hexagon(
              center: Offset(x * i, y + 3 * radius * H),
              radius: radius,
              color: buttonColor),
      ],
    );
  }
}
