import 'dart:async';

import 'package:cube_painter/alert.dart';
import 'package:cube_painter/asset_icons.dart';
import 'package:cube_painter/buttons/flat_hexagon_button.dart';
import 'package:cube_painter/buttons/thumbnail_button.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/persisted/painting_bank.dart';
import 'package:cube_painter/persisted/persister.dart';
import 'package:cube_painter/transform/screen_size.dart';
import 'package:flutter/material.dart';

const noWarn = out;

/// Like a 'File' menu, this allows loading, saving of painting files.
class PaintingsMenu extends StatelessWidget {
  const PaintingsMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screenAdjust(isPortrait(context) ? 0.56 : 0.888, context),
      child: Drawer(
        // Wrapping with SafeArea here would cause shift to right on iphone
        child: isPortrait(context)
            ? Column(
                children: [
                  const _TitleAndTopButtons(),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: _buildThumbnailButtonList(context),
                    ),
                  ),
                ],
              )
            : ListView(
                padding: EdgeInsets.zero,
                children: [
                  const _TitleAndTopButtons(),
                  ..._buildThumbnailButtonList(context),
                ],
              ),
      ),
    );
  }

  List<Widget> _buildThumbnailButtonList(
    BuildContext context,
  ) {
    final PaintingEntries paintingEntries =
        getPaintingBank(context, listen: true).paintingEntries;

    return List.generate(
      paintingEntries.length,
      (i) => Align(
        heightFactor: isPortrait(context) ? 0.87 : 0.464,
        alignment: i.isEven ? Alignment.centerLeft : Alignment.centerRight,
        child: ThumbnailButton(
          tip: 'Load this painting',
          onPressed: () =>
              _loadFile(filePath: paintingEntries[i].key, context: context),
          painting: paintingEntries[i].value,
        ),
      ),
    );
  }

  void _loadFile(
      {required String filePath, required BuildContext context}) async {
    final paintingBank = getPaintingBank(context);

    if (!paintingBank.modified ||
        await _askSaveCurrent(title: 'Load Painting', context: context)) {
      paintingBank.loadFile(filePath: filePath, context: context);
    }
  }
}

class _IconButtonRow extends StatelessWidget {
  const _IconButtonRow({Key? key}) : super(key: key);

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

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _ScreenAdjustedIconFlatHexagonButton(
          onPressed: pop(_newFile),
          tip: 'Create a new painting',
          icon: AssetIcons.docNew,
          iconSize: screenAdjustAssetIconSize(context) * 0.95,
        ),
        _ScreenAdjustedIconFlatHexagonButton(
          onPressed: paintingBank.modified ? dontPop(_saveFile) : null,
          tip: 'Save the current painting',
          icon: Icons.save,
          iconSize: screenAdjustNormalIconSize(context),
        ),
        _ScreenAdjustedIconFlatHexagonButton(
          onPressed: dontPop(_saveACopyFile),
          tip: 'Create a copy\nof this painting\nand load it.',
          icon: AssetIcons.copy,
          iconSize: screenAdjustAssetIconSize(context),
        ),
        _ScreenAdjustedIconFlatHexagonButton(
          onPressed: dontPop(_deleteCurrentFile),
          tip:
              'Delete the current painting.\n\nThe next painting\nis loaded\n\nor a new blank one\nis created.',
          icon: Icons.delete,
          iconSize: screenAdjustNormalIconSize(context),
        ),
      ],
    );
  }

  void _newFile(BuildContext context) async {
    final paintingBank = getPaintingBank(context);

    if (!paintingBank.modified ||
        await _askSaveCurrent(title: 'New Painting', context: context)) {
      paintingBank.finishAnim();

      await paintingBank.newFile(context);
    }
  }

  void _saveFile(BuildContext context) async =>
      await getPaintingBank(context).saveFile();

  void _saveACopyFile(BuildContext context) async =>
      await getPaintingBank(context).saveACopyFile();

  void _deleteCurrentFile(BuildContext context) async =>
      await getPaintingBank(context).deleteCurrentFile(context);
}

class _TitleAndTopButtons extends StatelessWidget {
  const _TitleAndTopButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final padY = SizedBox(height: screenAdjust(0.03247, context));

    return Column(
      children: [
        /// Padding for the safe area at the top
        SizedBox(height: MediaQuery.of(context).padding.top),
        padY,
        const Center(child: Text('Paintings')),
        padY,
        const _IconButtonRow(),
        SizedBox(
            height: screenAdjust(isPortrait(context) ? 0.04 : 0.09, context)),
      ],
    );
  }
}

/// Transparent flat hexagon shaped button with an icon.
/// A convenience for use at the top of the [PaintingsMenu] (the file menu).
class _ScreenAdjustedIconFlatHexagonButton extends StatelessWidget {
  const _ScreenAdjustedIconFlatHexagonButton({
    Key? key,
    this.onPressed,
    required this.tip,
    required this.icon,
    required this.iconSize,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final String tip;

  final IconData icon;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final p = isPortrait(context) ? 0.8 : 1.0;

    return SizedBox(
      width: screenAdjustButtonWidth(context) * p,
      child: IconFlatHexagonButton(
        onPressed: onPressed,
        tip: tip,
        icon: icon,
        iconSize: iconSize,
      ),
    );
  }
}

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
