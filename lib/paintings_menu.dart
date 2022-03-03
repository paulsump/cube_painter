import 'dart:async';

import 'package:cube_painter/alert.dart';
import 'package:cube_painter/asset_icons.dart';
import 'package:cube_painter/buttons/flat_hexagon_button.dart';
import 'package:cube_painter/buttons/thumbnail_button.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/persisted/sketch_bank.dart';
import 'package:cube_painter/transform/screen_size.dart';
import 'package:flutter/material.dart';

const noWarn = out;

/// padding for the safe area at the top
class _SafePad extends StatelessWidget {
  const _SafePad({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      SizedBox(height: MediaQuery.of(context).padding.top);
}

class PaintingsMenu extends StatefulWidget {
  const PaintingsMenu({Key? key}) : super(key: key);

  @override
  State<PaintingsMenu> createState() => _PaintingsMenuState();
}

class _PaintingsMenuState extends State<PaintingsMenu> {
  @override
  Widget build(BuildContext context) {
    final sketchBank = getSketchBank(context, listen: true);

    pop(funk) => () async {
          await funk();
          Navigator.of(context).pop();
        };

    const double offsetX = 55;
    const padY = SizedBox(height: 15.0);

    return Drawer(
      // Wrapping with SafeArea here would cause shift to right on iphone
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const _SafePad(),
          padY,
          const Center(child: Text('Paintings')),
          padY,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconFlatHexagonButton(
                onPressed: pop(_newFile),
                tip: 'Create a new painting',
                icon: AssetIcons.docNew,
                iconSize: calcAssetIconSize(context) * 0.96,
              ),
              IconFlatHexagonButton(
                onPressed: sketchBank.modified ? _saveFile : null,
                tip: 'Save the current painting',
                icon: Icons.save,
                iconSize: calcNormalIconSize(context),
              ),
              IconFlatHexagonButton(
                onPressed: _saveACopyFile,
                tip: 'Create a copy of this painting and load it.',
                icon: AssetIcons.copy,
                iconSize: calcAssetIconSize(context),
              ),
              IconFlatHexagonButton(
                onPressed: _deleteCurrentFile,
                tip:
                    'Delete the current painting. The next painting is loaded or a new blank one is created.',
                icon: Icons.delete,
                iconSize: calcNormalIconSize(context),
              ),
            ],
          ),
          const SizedBox(height: 5.0),
          const Divider(),
          for (int i = 0; i < sketchBank.sketchEntries.length; ++i)
            Transform.translate(
              offset: Offset((i % 2 == 0 ? -1 : 1) * offsetX, 0),
              child: ThumbnailButton(
                tip: 'Load this painting',
                onPressed: () =>
                    _loadFile(filePath: sketchBank.sketchEntries[i].key),
                sketch: sketchBank.sketchEntries[i].value,
              ),
            ),
          const Divider(),
        ],
      ),
    );
  }

  void _newFile() async {
    final sketchBank = getSketchBank(context);

    if (!sketchBank.modified || await _askSaveCurrent(title: 'New Painting')) {
      await sketchBank.newFile(context);
      setState(() {});
    }
  }

  void _loadFile({required String filePath}) async {
    final sketchBank = getSketchBank(context);

    if (!sketchBank.modified || await _askSaveCurrent(title: 'Load Painting')) {
      sketchBank.loadFile(filePath: filePath, context: context);
      setState(() {});
    }
  }

  void _saveFile() async {
    final sketchBank = getSketchBank(context);

    await sketchBank.saveFile();
    setState(() {});
  }

  void _saveACopyFile() async {
    final sketchBank = getSketchBank(context);

    await sketchBank.saveACopyFile();
    setState(() {});
  }

  void _deleteCurrentFile() async {
    if (await _askDelete()) {
      final sketchBank = getSketchBank(context);

      await sketchBank.deleteCurrentFile(context);
      setState(() {});
    }
  }

  Future<bool> _askDelete() async {
    return await _askYesNoOrCancel(
      title: 'Delete',
      content: 'Delete the current painting?',
      yesTip: 'Delete the current painting.',
      wantOnlyYesAndCancelButtons: true,
    );
  }

  Future<bool> _askSaveCurrent({required String title}) async {
    return await _askYesNoOrCancel(
      title: title,
      content: 'Save the current changes?',
      yesCallBack: getSketchBank(context).saveFile,
      yesTip: 'Save the current painting with your new changes.',
      noCallBack: getSketchBank(context).resetCurrentSketch,
      noTip: 'Reset the current painting to how it was when opened.',
    );
  }

  Future<bool> _askYesNoOrCancel({
    required String title,
    required String content,
    Future<void> Function()? yesCallBack,
    String? yesTip,
    Future<void> Function()? noCallBack,
    String? noTip,
    bool wantOnlyYesAndCancelButtons = false,
  }) async {
    final alert = Alert(
      title: title,
      content: content,
      yesCallBack: () {
        unawaited(yesCallBack?.call());
        Navigator.of(context).pop(true);
      },
      yesTip: yesTip,
      noCallBack: wantOnlyYesAndCancelButtons
          ? null
          : () {
              unawaited(noCallBack?.call());
              Navigator.of(context).pop(true);
            },
      noTip: noTip,
      cancelCallBack: () => Navigator.of(context).pop(false),
    );

    final bool? clickedYes = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );

    return clickedYes ?? false;
  }
}
