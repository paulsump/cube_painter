import 'package:cube_painter/alert.dart';
import 'package:cube_painter/asset_icons.dart';
import 'package:cube_painter/buttons/elevated_hexagon_button.dart';
import 'package:cube_painter/buttons/radio_button.dart';
import 'package:cube_painter/colors.dart';
import 'package:cube_painter/gesture_mode.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/persisted/slice.dart';
import 'package:cube_painter/transform/screen_size.dart';
import 'package:cube_painter/undo_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const noWarn = [out];

/// Just a container for all the button on the main [PainterPage].
/// Organised using [Column]s and [Row]s
class PageButtons extends StatelessWidget {
  const PageButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final undoer = getUndoer(context, listen: true);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _OpenPaintingsMenuButton(),
                (undoer.canUndo || undoer.canRedo)
                    ? const _UndoButton()
                    : const _HelpButton(),
                const _UndoButton(isRedo: true),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CubeLineRadioButton(
                  isRadioOn: GestureMode.addLine ==
                      getGestureMode(context, listen: true),
                  icon: AssetIcons.plusOutline,
                  onPressed: () => setGestureMode(GestureMode.addLine, context),
                  tip:
                      "\n\nDrag on the canvas to add a line of cubes.\n\nYou can change the direction while you drag.",
                ),
                CubeRadioButton(
                  isRadioOn: GestureMode.erase ==
                      getGestureMode(context, listen: true),
                  icon: AssetIcons.cancelOutline,
                  onPressed: () => setGestureMode(GestureMode.erase, context),
                  tip:
                      '\n\nDrag on the canvas to move an animating cube over the cube\n\nthat you want to delete, then release to delete it.',
                  slice: Slice.whole,
                ),
                const _OpenSliceMenuButton(),
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
        Icons.folder_open_outlined,
        color: enabledIconColor,
        size: calcNormalIconSize(context) * 1.22,
      ),
      onPressed: Scaffold.of(context).openDrawer,
      tip: '\n\nOpen the paintings menu.',
    );
  }
}

/// Pressing this button shows the [HelpAlert].
class _HelpButton extends StatelessWidget {
  const _HelpButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedHexagonButton(
      child: Icon(
        Icons.help_outline_rounded,
        color: enabledIconColor,
        size: calcNormalIconSize(context) * 1.09,
      ),
      onPressed: () => _showHelp(context),
      tip: '\n\nShows the help message.',
    );
  }
}

/// Show a little message to get them started.
void _showHelp(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) => Alert(
      title: 'Cube Painter',
      content: 'Drag to draw cubes.\n\n'
          'Pinch to zoom and pan.\n\n'
          'Long press a button to see tooltip.',
      yesCallBack: () {
        Navigator.of(context).pop(true);
      },
      yesTip: 'Close the help message',
    ),
  );
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
        size: calcNormalIconSize(context) * 1.2,
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

class _OpenSliceMenuButton extends StatelessWidget {
  const _OpenSliceMenuButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gestureModeNotifier =
    Provider.of<GestureModeNotifier>(context, listen: true);

    final Slice slice = gestureModeNotifier.slice;
    final GestureMode currentGestureMode = gestureModeNotifier.gestureMode;

    return CubeRadioButton(
      slice: slice,
      isRadioOn: currentGestureMode == GestureMode.addSlice,
      icon: AssetIcons.plusOutline,
      onPressed: Scaffold.of(context).openEndDrawer,
      tip:
          '\n\nDrag on the canvas to move\n\nan animating slice of a cube.\n\nThen release to place it.',
    );
  }
}
