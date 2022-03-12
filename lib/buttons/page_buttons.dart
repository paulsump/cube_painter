// Copyright (c) 2022, Paul Sumpner.  All rights reserved.

import 'package:cube_painter/asset_icons.dart';
import 'package:cube_painter/buttons/elevated_hexagon_button.dart';
import 'package:cube_painter/buttons/radio_button.dart';
import 'package:cube_painter/gestures/brush.dart';
import 'package:cube_painter/help_page.dart';
import 'package:cube_painter/hue.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/persisted/slice.dart';
import 'package:cube_painter/transform/screen_adjust.dart';
import 'package:cube_painter/undo_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const noWarn = [out];

/// A container for all the buttons on the main [PainterPage].
///
/// Organised using [Column]s and [Row]s
class PageButtons extends StatelessWidget {
  const PageButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final undoer = getUndoer(context, listen: true);

    //todo maybe hide page buttons if showing help
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
                    ? const _UndoButton(isRedo: false)
                    : const _HelpButton(),
                const _UndoButton(isRedo: true),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CubeLineRadioButton(
                  isRadioOn: Brush.addLine == getBrush(context, listen: true),
                  icon: AssetIcons.plusOutline,
                  iconSize: screenAdjustAddIconSize(context),
                  diagonalOffset: -0.002,
                  onPressed: () => setBrush(Brush.addLine, context),
                  tip:
                  "Drag on the canvas\nto add a line of cubes.\n\nYou can change\nthe direction\nwhile you drag.",
                  wire: false,
                ),
                CubeLineRadioButton(
                  isRadioOn: Brush.eraseLine == getBrush(context, listen: true),
                  icon: AssetIcons.cancelOutline,
                  iconSize: screenAdjustEraseIconSize(context),
                  diagonalOffset: 0.004,
                  onPressed: () => setBrush(Brush.eraseLine, context),
                  tip:
                  'Drag on the canvas to\ndelete a line of cubes.\n\nYou can change\nthe direction\nwhile you drag.',
                  wire: true,
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

/// Pressing this [ElevatedHexagonButton] opens up the [Drawer] for the
/// [PaintingsMenu] (the file menu).
class _OpenPaintingsMenuButton extends StatelessWidget {
  const _OpenPaintingsMenuButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedHexagonButton(
      child: Icon(
        Icons.folder_open_outlined,
        color: Hue.enabledIcon,
        size: screenAdjustNormalIconSize(context),
      ),
      onPressed: Scaffold.of(context).openDrawer,
      tip: 'Open the paintings menu.',
    );
  }
}

/// An undo or a redo button.
///
/// Pressing it will undo the previous action.
/// The redo button appears only if undo was pressed.
class _UndoButton extends StatelessWidget {
  const _UndoButton({Key? key, required this.isRedo}) : super(key: key);

  final bool isRedo;

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
        size: screenAdjustNormalIconSize(context),
        color: enabled ? Hue.enabledIcon : Hue.disabledIcon,
      ),
      onPressed: enabled
          ? isRedo
          ? () => undoer.redo(context)
          : () => undoer.undo(context)
          : null,
      tip: isRedo
          ? 'Redo the last add or delete that was undone.'
          : 'Undo the last add or delete.',
    )
        : Container();
  }
}

/// Pressing this button shows the [HelpPage].
class _HelpButton extends StatelessWidget {
  const _HelpButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedHexagonButton(
      child: Icon(
        Icons.help_outline_rounded,
        color: Hue.enabledIcon,
        size: screenAdjustNormalIconSize(context),
      ),
      onPressed: () => setShowHelp(true, context),
      tip: 'Display tips.',
    );
  }
}

/// Opens the right hand [Drawer]
class _OpenSliceMenuButton extends StatelessWidget {
  const _OpenSliceMenuButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final brushNotifier = Provider.of<BrushNotifier>(context, listen: true);

    final Slice slice = brushNotifier.slice;
    final Brush currentBrush = brushNotifier.brush;

    return CubeRadioButton(
      slice: slice,
      isRadioOn: currentBrush == Brush.addSlice,
      icon: AssetIcons.plusOutline,
      iconSize: screenAdjustAddIconSize(context),
      onPressed: Scaffold.of(context).openEndDrawer,
      tip: 'Choose which cube slice to add...',
    );
  }
}
