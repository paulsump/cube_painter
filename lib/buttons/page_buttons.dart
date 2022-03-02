import 'package:cube_painter/asset_icons.dart';
import 'package:cube_painter/buttons/cube_button.dart';
import 'package:cube_painter/buttons/elevated_hexagon_button.dart';
import 'package:cube_painter/buttons/slice_cube_button.dart';
import 'package:cube_painter/colors.dart';
import 'package:cube_painter/constants.dart';
import 'package:cube_painter/gesture_mode.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/undo_notifier.dart';
import 'package:flutter/material.dart';

const noWarn = [out];

/// Just a container for all the button on the main [PainterPage].
/// Organised using [Column]s and [Row]s
class PageButtons extends StatelessWidget {
  const PageButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _OpenPaintingsMenuButton(),
                _UndoButton(),
                _UndoButton(isRedo: true),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _GestureModeCubeElevatedHexagonButton(
                  mode: GestureMode.addWhole,
                  icon: AssetIcons.plusOutline,
                  tip:
                      'Tap or drag on the canvas to add a row of cubes. You can change the direction while you drag.',
                ),
                _GestureModeCubeElevatedHexagonButton(
                  mode: GestureMode.erase,
                  icon: AssetIcons.cancelOutline,
                  tip:
                      'Tap on a cube to delete it.  You can change the position while you have your finger down.',
                ),
                OpenSliceMenuButton(),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

/// Pressing this button opens up the [Drawer] for the
/// [PaintingsMenu] (the file menu).
class _OpenPaintingsMenuButton extends StatelessWidget {
  const _OpenPaintingsMenuButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedHexagonButton(
      child: Icon(
        Icons.folder_sharp,
        color: enabledIconColor,
        size: normalIconSize,
      ),
      onPressed: Scaffold.of(context).openDrawer,
      tip: 'Open the file menu.',
    );
  }
}

/// An undo or a redo button.
/// Pressing it will undo the previous action.
/// The redo button appears only if undo was pressed.
class _UndoButton extends StatelessWidget {
  final bool isRedo;

  const _UndoButton({
    Key? key,
    this.isRedo = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final undoer = getUndoer(context, listen: true);

    final bool canUndo = undoer.canUndo;
    final bool canRedo = undoer.canRedo;

    final bool wantShow = isRedo ? canRedo : canUndo || canRedo;
    final bool enabled = isRedo ? canRedo : canUndo;

    return wantShow
        ? ElevatedHexagonButton(
            child: Icon(
              isRedo ? Icons.redo_sharp : Icons.undo_sharp,
              size: normalIconSize * 1.2,
              color: enabled ? enabledIconColor : disabledIconColor,
            ),
            onPressed: enabled
                ? isRedo
                    ? () => undoer.redo(context)
                    : () => undoer.undo(context)
                : null,
            tip: isRedo
                ? 'Redo the last add or delete operation that was undone.'
                : 'Undo the last add or delete operation.',
          )
        : Container();
  }
}

/// A radio button with a cube.
/// Used for setting [GestureMode].
class _GestureModeCubeElevatedHexagonButton extends StatelessWidget {
  final GestureMode mode;

  final IconData icon;
  final String tip;

  const _GestureModeCubeElevatedHexagonButton({
    Key? key,
    required this.mode,
    required this.icon,
    required this.tip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gestureMode = getGestureMode(context, listen: true);

    return CubeElevatedHexagonButton(
      isRadioOn: mode == gestureMode,
      icon: icon,
      iconSize: assetIconSize,
      onPressed: () => setGestureMode(mode, context),
      tip: tip,
    );
  }
}
