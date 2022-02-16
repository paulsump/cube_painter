import 'package:cube_painter/buttons/hexagon_button.dart';
import 'package:cube_painter/buttons/hexagon_button_bar_creator.dart';
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
  final ScreenMaths maths;

  double get height => maths.height;

  double get offsetY => maths.offsetY;

  double get radius => maths.radius;

  double get x => maths.x;

  double get y => maths.y;

  double get gap => maths.gap;

  bool get orient => maths.orient;

  const HexagonButtonBar({
    Key? key,
    required this.undoer,
    required this.saveToClipboard,
    required this.maths,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screen = getScreen(context, listen: true);

    final basicButtonInfo = [
      BasicButtonInfo(
        enabled: undoer.canUndo,
        icon: Icons.undo_sharp,
        onPressed: undoer.undo,
        tip: 'Undo the last add or delete operation.',
        offset: Offset(gap, 0),
        orientOffset: Offset(gap - radius * 0.1, gap),
      ),
      BasicButtonInfo(
        enabled: undoer.canRedo,
        icon: Icons.redo_sharp,
        onPressed: undoer.redo,
        tip: 'Redo the last add or delete operation that was undone.',
        offset: Offset(radius * 0.1 - gap, 0),
        orientOffset: Offset(radius * 0.1 - gap / 2, -radius * 0.1),
      ),
      BasicButtonInfo(
        enabled: true,
        icon: Icons.forward,
        onPressed: () => getCubeGroupNotifier(context).increment(1),
        tip: 'Load next group of cubes.',
        offset: Offset(-1 * gap, 0),
        orientOffset: Offset(-radius * 0.1, -radius * 0.10),
      ),
      BasicButtonInfo(
        enabled: true,
        icon: Icons.save_alt_sharp,
        onPressed: saveToClipboard,
        tip: 'Save the current group of cubes to the clipboard.',
        offset: Offset(gap, 0),
        orientOffset: Offset(gap, 0),
      ),
    ];

    final borderSide = BorderSide(width: 1.0, color: buttonColor);

    return Transform.translate(
      offset: Offset(0, offsetY),
      child: Container(
        width: orient ? screen.width / 8 : screen.width,
        height: !orient ? screen.width : screen.width,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border(
            top: borderSide,
            right: borderSide,
          ),
        ),
        child: Stack(
          children: [
            _buildGestureModeButton(0, context),
            for (int i = 1; i < GestureMode.values.length; ++i)
              _buildGestureModeButton(i, context),
            for (int i = 0; i < basicButtonInfo.length; ++i)
              _buildBasicButton(i, basicButtonInfo, context),
          ],
        ),
      ),
    );
  }

  Offset _getGestureModeButtonOffset(int i) {
    final double w = W * radius;

    if (orient) {
      final X = x * 1.1;

      final double Y = y * (i * 1.5 + 1);
      return i % 2 == 0 ? Offset(X - w, Y) : Offset(X, Y);
    }
    return Offset(x * (i + 0.5), y);
  }

  Offset _getBasicButtonOffset(int i) =>
      _getGestureModeButtonOffset(i + GestureMode.values.length);

  Widget _buildGestureModeButton(int i, BuildContext context) {
    if (i == 0) {
      return HexagonButton(
        icon: Icons.zoom_in_rounded,
        gestureMode: GestureMode.panZoom,
        center: _getGestureModeButtonOffset(i),
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
        center: _getGestureModeButtonOffset(i),
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
      int i, List<BasicButtonInfo> buttonInfos, BuildContext context) {
    final BasicButtonInfo info = buttonInfos[i];
    final Offset extraOffset = orient ? info.orientOffset : info.offset;

    return HexagonButton(
      enabled: info.enabled,
      icon: info.icon,
      onPressed: info.onPressed,
      center: _getBasicButtonOffset(i) + extraOffset,
      radius: radius - gap,
    );
  }
}

class BasicButtonInfo {
  final bool enabled;
  final IconData icon;
  final VoidCallback onPressed;
  final String tip;
  final Offset offset;
  final Offset orientOffset;

  const BasicButtonInfo({
    required this.enabled,
    required this.icon,
    required this.onPressed,
    required this.tip,
    required this.offset,
    required this.orientOffset,
  });
}
