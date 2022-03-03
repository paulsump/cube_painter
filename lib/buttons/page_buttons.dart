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
                      "Drag on the canvas\nto add a line of cubes.\n\nYou can change the direction\nwhile you drag.",
                ),
                CubeRadioButton(
                  isRadioOn: GestureMode.eraseLine ==
                      getGestureMode(context, listen: true),
                  icon: AssetIcons.cancelOutline,
                  onPressed: () =>
                      setGestureMode(GestureMode.eraseLine, context),
                  tip:
                      'Drag on the canvas to\nmove an animating cube.\n\nPlace it over\nthe cube that you want to delete.\n\nThen release to delete it.',
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
      tip: 'Open the paintings menu.',
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
        size: calcNormalIconSize(context) * 1.25,
      ),
      onPressed: () => _showHelp(context),
      tip: 'Display tips.',
    );
  }
}

/// Show a little message to get them started.
void _showHelp(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      const title = TextStyle(
        fontWeight: FontWeight.bold,
      );

      const emphasize = TextStyle(
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
        decoration: TextDecoration.underline,
      );

      return Alert(
        title: 'Tips',
        child: RichText(
          text: TextSpan(
            text: '\n',
            style:
                DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.7),
            children: const <TextSpan>[
              TextSpan(text: 'Add cubes', style: title),
              TextSpan(text: '...\n\nDrag with '),
              TextSpan(text: 'one', style: emphasize),
              TextSpan(text: ' finger.\n\n\n'),
              TextSpan(text: 'Pan and Zoom', style: title),
              TextSpan(text: '...\n\nDrag with '),
              TextSpan(text: 'two', style: emphasize),
              TextSpan(text: ' fingers.\n\n\n'),
              TextSpan(text: 'Button tips', style: title),
              TextSpan(text: '...\n\nPress and hold a button.'),
            ],
          ),
        ),
        yesCallBack: () => Navigator.of(context).pop(),
        yesTip: 'Done',
      );
    },
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
      tip: 'Choose which cube slice to add...',
    );
  }
}
