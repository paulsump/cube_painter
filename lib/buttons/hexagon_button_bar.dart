import 'package:cube_painter/buttons/hexagon_button.dart';
import 'package:cube_painter/colors.dart';
import 'package:cube_painter/cubes/crop_unit_cube.dart';
import 'package:cube_painter/cubes/full_unit_cube.dart';
import 'package:cube_painter/data/crop.dart';
import 'package:cube_painter/data/cube_group.dart';
import 'package:cube_painter/gesture_mode.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/transform/position_to_unit.dart';
import 'package:cube_painter/transform/screen.dart';
import 'package:cube_painter/undoer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const noWarn = out;

class HexagonButtonBar extends StatelessWidget {
  final Undoer undoer;

  final VoidCallback saveToClipboard;
  final double height;

  final double offsetY;

  double get radius => height / 2;

  double get x => 2 * radius * W;

  double get y => 2 * radius * H;

  const HexagonButtonBar({
    Key? key,
    required this.undoer,
    required this.saveToClipboard,
    //TOOD CALC in build() from screen
    required this.height,
    required this.offsetY,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screen = getScreen(context, listen: true);
    final bool orient = screen.height < screen.width;

    final basicButtonInfo = [
      BasicButtonInfo(
        enabled: undoer.canUndo,
        icon: Icons.undo_sharp,
        onPressed: undoer.undo,
        tip: 'Undo the last add or delete operation.',
      ),
      BasicButtonInfo(
        enabled: undoer.canRedo,
        icon: Icons.redo_sharp,
        onPressed: undoer.redo,
        tip: 'Redo the last add or delete operation that was undone.',
      ),
      BasicButtonInfo(
        enabled: true,
        icon: Icons.forward,
        onPressed: () => getCubeGroupNotifier(context).increment(1),
        tip: 'Load next group of cubes.',
      ),
      BasicButtonInfo(
        enabled: true,
        icon: Icons.save_alt_sharp,
        onPressed: saveToClipboard,
        tip: 'Save the current group of cubes to the clipboard.',
      ),
    ];

    final borderSide = BorderSide(width: 1.0, color: buttonColor);

    return Transform.translate(
      offset: Offset(0, orient ? 0 : offsetY - height),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border(
            top: borderSide,
            right: borderSide,
          ),
        ),
        child: Stack(
          children: [
            _buildGestureModeButton(0, context, orient),
            for (int i = 1; i < GestureMode.values.length; ++i)
              _buildGestureModeButton(i, context, orient),
            for (int i = 0; i < basicButtonInfo.length; ++i)
              _buildBasicButton(i, basicButtonInfo, context, orient),
          ],
        ),
      ),
    );
  }

  /// TODO ORient
  Offset _getGestureModeButtonOffset(int i, bool orient) {
    final double w = W * radius;
    if (orient) {
      final double Y = y * (i * 1.5 + 1);
      return i % 2 == 0 ? Offset(x - w, Y) : Offset(x, Y);
    }
    return Offset(x * (i + 0.5), y);
  }

  Offset _getBasicButtonOffset(int i, bool orient) =>
      _getGestureModeButtonOffset(i + GestureMode.values.length, orient);

  Widget _buildGestureModeButton(int i, BuildContext context, bool orient) {
    if (i == 0) {
      return HexagonButton(
        icon: Icons.zoom_in_rounded,
        gestureMode: GestureMode.panZoom,
        center: _getGestureModeButtonOffset(i, orient),
        radius: radius,
      );
    } else {
      final Crop crop = Provider.of<CropNotifier>(context, listen: true).crop;

      final gestureModeButtonInfo = [
        [],
        [
          Icons.add,
          const FullUnitCube(),
          // 'Tap or drag on the canvas to add a row of cubes. You can change the direction while you drag.'),
        ],
        [
          Icons.remove,
          const FullUnitCube(),
          // 'Tap on a cube to delete it.  You can change the position while you have your finger down.'),
        ],
        [
          Icons.add,
          CropUnitCube(crop: crop),
          // 'Tap to add half a cube.  Cycle through the six options by pressing this button again.  You can change the position while you have your finger down.'),
        ],
      ];

      return HexagonButton(
        icon: gestureModeButtonInfo[i][0] as IconData,
        iconOffset: const Offset(W, H) * -radius * 0.5,
        unitChild: gestureModeButtonInfo[i][1] as Widget,
        gestureMode: GestureMode.values[i],
        center: _getGestureModeButtonOffset(i, orient),
        radius: radius,
        onPressed: i == 3
            ? () {
                final cropNotifier =
                    Provider.of<CropNotifier>(context, listen: false);
                cropNotifier.increment(-1);
              }
            : null,
      );
    }
  }

  Widget _buildBasicButton(
    int i,
    List<BasicButtonInfo> buttonInfos,
    BuildContext context,
    bool orient,
  ) =>
      HexagonButton(
        enabled: buttonInfos[i].enabled,
        icon: buttonInfos[i].icon,
        onPressed: buttonInfos[i].onPressed,
        center: _getBasicButtonOffset(i, orient),
        radius: radius,
      );
}

class BasicButtonInfo {
  final bool enabled;
  final IconData icon;
  final VoidCallback onPressed;
  final String tip;

  const BasicButtonInfo({
    required this.enabled,
    required this.icon,
    required this.onPressed,
    required this.tip,
  });
}
