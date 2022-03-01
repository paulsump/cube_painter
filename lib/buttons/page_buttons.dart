import 'package:cube_painter/buttons/gesture_mode_cube_button.dart';
import 'package:cube_painter/buttons/hexagon_elevated_button.dart';
import 'package:cube_painter/buttons/paintings_menu_buttons.dart';
import 'package:cube_painter/buttons/slice_cube_button.dart';
import 'package:cube_painter/colors.dart';
import 'package:cube_painter/constants.dart';
import 'package:cube_painter/downloaded_icons.dart';
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
                OpenPaintingsMenuButton(),
                _UndoButton(),
                _UndoButton(isRedo: true),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                GestureModeCubeButton(
                  mode: GestureMode.addWhole,
                  icon: DownloadedIcons.plusOutline,
                  tip:
                      'Tap or drag on the canvas to add a row of cubes. You can change the direction while you drag.',
                ),
                GestureModeCubeButton(
                  mode: GestureMode.erase,
                  icon: DownloadedIcons.cancelOutline,
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
        ? HexagonElevatedButton(
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
