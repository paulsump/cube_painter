import 'dart:async';

import 'package:cube_painter/alert.dart';
import 'package:cube_painter/asset_icons.dart';
import 'package:cube_painter/buttons/flat_hexagon_button.dart';
import 'package:cube_painter/buttons/thumbnail_button.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/persisted/painting_bank.dart';
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

/// Like a 'File' menu, this allows loading, saving of painting files.
class PaintingsMenu extends StatelessWidget {
  const PaintingsMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final paintingBank = getPaintingBank(context, listen: true);

    pop(funk) => () async {
          await funk(context);
          Navigator.of(context).pop();
        };

    dontPop(funk) => () async {
          await funk(context);
        };

    final double offsetX = screenAdjust(0.11905, context);
    final padY = SizedBox(height: screenAdjust(0.03247, context));

    return SizedBox(
      width: screenAdjust(0.75, context),
      child: Drawer(
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
                  iconSize: screenAdjustAssetIconSize(context) * 0.95,
                ),
                IconFlatHexagonButton(
                  onPressed: paintingBank.modified ? dontPop(_saveFile) : null,
                  tip: 'Save the current painting',
                  icon: Icons.save,
                  iconSize: screenAdjustNormalIconSize(context),
                ),
                IconFlatHexagonButton(
                  onPressed: dontPop(_saveACopyFile),
                  tip: 'Create a copy\nof this painting\nand load it.',
                  icon: AssetIcons.copy,
                  iconSize: screenAdjustAssetIconSize(context),
                ),
                IconFlatHexagonButton(
                  onPressed: dontPop(_deleteCurrentFile),
                  tip:
                      'Delete the current painting.\n\nThe next painting\nis loaded\n\nor a new blank one\nis created.',
                  icon: Icons.delete,
                  iconSize: screenAdjustNormalIconSize(context),
                ),
              ],
            ),
            SizedBox(height: screenAdjust(0.01082, context)),
            const Divider(),
            for (int i = 0; i < paintingBank.paintingEntries.length; ++i)
              Transform.translate(
                offset: Offset((i % 2 == 0 ? -1 : 1) * offsetX, 0),
                child: ThumbnailButton(
                  tip: 'Load this painting',
                  onPressed: () => _loadFile(
                      filePath: paintingBank.paintingEntries[i].key,
                      context: context),
                  painting: paintingBank.paintingEntries[i].value,
                ),
              ),
            const Divider(),
          ],
        ),
      ),
    );
  }

  void _newFile(BuildContext context) async {
    final paintingBank = getPaintingBank(context);

    if (!paintingBank.modified ||
        await _askSaveCurrent(title: 'New Painting', context: context)) {
      await paintingBank.newFile(context);
    }
  }

  void _loadFile(
      {required String filePath, required BuildContext context}) async {
    final paintingBank = getPaintingBank(context);

    if (!paintingBank.modified ||
        await _askSaveCurrent(title: 'Load Painting', context: context)) {
      paintingBank.loadFile(filePath: filePath, context: context);
    }
  }

  void _saveFile(BuildContext context) async =>
      await getPaintingBank(context).saveFile();

  void _saveACopyFile(BuildContext context) async =>
      await getPaintingBank(context).saveACopyFile();

  void _deleteCurrentFile(BuildContext context) async =>
      await getPaintingBank(context).deleteCurrentFile(context);

  Future<bool> _askSaveCurrent({
    required String title,
    required BuildContext context,
  }) async {
    return await _askYesNoOrCancel(
      title: title,
      content: 'Save the current changes?',
      yesCallBack: getPaintingBank(context).saveFile,
      yesTip: 'Save the current painting\nwith your new changes.',
      noCallBack: getPaintingBank(context).resetCurrentPainting,
      noTip: 'Reset the current painting\nto how it was when opened.',
      context: context,
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
    required BuildContext context,
  }) async {
    final alert = Alert(
      title: title,
      child: Text(content),
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
