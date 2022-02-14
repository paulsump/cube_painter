import 'package:cube_painter/buttons/hexagon.dart';
import 'package:cube_painter/buttons/hexagon_button.dart';
import 'package:cube_painter/colors.dart';
import 'package:cube_painter/cubes/simple_unit_cube.dart';
import 'package:cube_painter/cubes/unit_cube.dart';
import 'package:cube_painter/data/crop.dart';
import 'package:cube_painter/data/cube_group.dart';
import 'package:cube_painter/gesture_mode.dart';
import 'package:cube_painter/transform/position_to_unit.dart';
import 'package:cube_painter/undoer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HexagonButtonBar extends StatelessWidget {
  final Undoer undoer;
  final VoidCallback saveToClipboard;

  const HexagonButtonBar({
    Key? key,
    required this.undoer,
    required this.saveToClipboard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Crop crop = Provider.of<CropNotifier>(context, listen: true).crop;

    final gestureModeButtonInfo = [
      [],
      [Icons.add, const SimpleUnitCube()],
      [Icons.remove, const UnitCube(wire: true)],
      [Icons.add, UnitCube(crop: crop)],
    ];

    final otherButtonInfo = [
      [undoer.canUndo, Icons.undo_sharp, undoer.undo],
      [undoer.canRedo, Icons.redo_sharp, undoer.redo],
      [true, Icons.forward, () => getCubeGroupNotifier(context).increment(1)],
      [true, Icons.save_alt_sharp, saveToClipboard],
    ];

    const double radius = 40;

    const double x = 2 * radius * W;
    const double y = 3 * radius * H;

    return Stack(
      children: [
        const HexagonButton(
          icon: Icons.zoom_in_rounded,
          gestureMode: GestureMode.panZoom,
          center: Offset(x * 0.5, y),
          radius: radius,
        ),
        for (int i = 1; i < gestureModeButtonInfo.length; ++i)
          HexagonButton(
            icon: gestureModeButtonInfo[i][0] as IconData,
            iconOffset: const Offset(W, H) * -radius * 0.5,
            unitChild: gestureModeButtonInfo[i][1] as UnitCube,
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
          ),
        for (int i = 0; i < otherButtonInfo.length; ++i)
          HexagonButton(
            enabled: otherButtonInfo[i][0] as bool,
            icon: otherButtonInfo[i][1] as IconData,
            onPressed: otherButtonInfo[i][2] as VoidCallback,
            center: Offset(x * (i + 4.5), y),
            radius: radius,
          ),
        for (int i = 0;
            i < 1 + gestureModeButtonInfo.length + otherButtonInfo.length;
            ++i)
          Hexagon(
              center: Offset(x * i, y + 3 * radius * H),
              radius: radius,
              color: buttonColor),
      ],
    );
  }
}
