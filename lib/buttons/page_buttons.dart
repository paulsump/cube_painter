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
              const OpenPaintingsMenuButton(),
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
                  ]),
            ]),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(height: buttonElevation),
            const _UndoButton(),
            const _UndoButton(redo: true),
            // HACK without a big container, the buttons don't response, and now it's needed to stop the undo buttons being centered
            Container(),
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
  final bool redo;

  const _UndoButton({
    Key? key,
    this.redo = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final undoer = getUndoer(context);

    final bool canUndo = undoer.canUndo;
    final bool canRedo = undoer.canRedo;

    final bool show = redo ? canRedo : canUndo || canRedo;
    final bool enabled = redo ? canRedo : canUndo;

    return show
        ? HexagonElevatedButton(
            child: Icon(
              redo ? Icons.redo_sharp : Icons.undo_sharp,
        size: normalIconSize * 1.2,
        color: enabled ? enabledIconColor : disabledIconColor,
      ),
      onPressed: enabled
          ? redo
                    ? () => undoer.redo(context)
                    : () => undoer.undo(context)
                : null,
      tip: redo
          ? 'Redo the last add or delete operation that was undone.'
          : 'Undo the last add or delete operation.',
    )
        : Container();
  }
}
