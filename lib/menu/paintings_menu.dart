import 'package:cube_painter/alert.dart';
import 'package:cube_painter/buttons/hexagon_border_button.dart';
import 'package:cube_painter/buttons/thumbnail.dart';
import 'package:cube_painter/constants.dart';
import 'package:cube_painter/data/sketch.dart';
import 'package:cube_painter/downloaded_icons.dart';
import 'package:cube_painter/buttons/paintings_menu_button.dart';
import 'package:cube_painter/out.dart';
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
    final sketchBank = getSketchBank(context);

    pop(funk) => () {
          funk();
          Navigator.of(context).pop();
        };

    final items = <PaintingsMenuItem>[
      PaintingsMenuItem(
        tip: 'Create a new painting',
        icon: DownloadedIcons.docNew,
        iconSize: downloadedIconSize * 0.96,
        onPressed: pop(_newFile),
      ),
      PaintingsMenuItem(
        tip: 'Save the current painting',
        icon: Icons.save,
        iconSize: normalIconSize,
        onPressed: _saveFile,
        enabled: sketchBank.modified,
      ),
      PaintingsMenuItem(
        tip: 'Create a copy of this painting and load it.',
        icon: DownloadedIcons.copy,
        iconSize: downloadedIconSize,
        onPressed: _saveACopyFile,
      ),
      PaintingsMenuItem(
        tip:
            'Delete the current painting. The next painting is loaded or a new blank one is created.',
        icon: Icons.delete,
        iconSize: normalIconSize,
        onPressed: _deleteCurrentFile,
      ),
    ];

    const double offsetX = 55;
    const padY = SizedBox(height: 15.0);

    return LayoutBuilder(
      builder: (context, constraints) => Drawer(
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
                for (PaintingsMenuItem item in items)
                  PaintingsMenuButton(item: item),
              ],
            ),
            const SizedBox(height: 5.0),
            const Divider(),
            for (int i = 0; i < sketchBank.sketchEntries.length; ++i)
              Transform.translate(
                offset: Offset((i % 2 == 0 ? -1 : 1) * offsetX, 0),
                child: HexagonBorderButton(
                  tip: 'Load this painting',
                  onPressed: () =>
                      _loadFile(filePath: sketchBank.sketchEntries[i].key),
                  child: Thumbnail(sketch: sketchBank.sketchEntries[i].value),
                ),
              ),
            const Divider(),
          ],
        ),
      ),
    );
  }

  void _newFile() async {
    final sketchBank = getSketchBank(context);

    if (!sketchBank.modified || await _askSaveCurrent(title: 'New Painting')) {
      sketchBank.newFile();
      setState(() {});
    }
  }

  void _loadFile({required String filePath}) async {
    final sketchBank = getSketchBank(context);

    if (!sketchBank.modified || await _askSaveCurrent(title: 'Load Painting')) {
      sketchBank.loadFile(filePath: filePath);
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

      await sketchBank.deleteCurrentFile();
      setState(() {});
    }
  }

  Future<bool> _askDelete() async {
    return await _askYesNoOrCancel(
      title: 'Delete',
      content: 'Delete current painting?',
      onlyYesAndCancelButtons: true,
    );
  }

  Future<bool> _askSaveCurrent({required String title}) async {
    return await _askYesNoOrCancel(
      title: title,
      content: 'Save the current changes?',
      yesCallBack: getSketchBank(context).saveFile,
      noCallBack: getSketchBank(context).resetCurrentSketch,
    );
  }

  Future<bool> _askYesNoOrCancel({
    required String title,
    required String content,
    VoidCallback? yesCallBack,
    VoidCallback? noCallBack,
    bool onlyYesAndCancelButtons = false,
  }) async {
    final alert = Alert(
      title: title,
      content: content,
      yesCallBack: () {
        yesCallBack?.call();
        Navigator.of(context).pop(true);
      },
      noCallBack: onlyYesAndCancelButtons
          ? null
          : () {
              noCallBack?.call();
              Navigator.of(context).pop(true);
            },
      cancelCallBack: () => Navigator.of(context).pop(false),
    );

    final bool? yes = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );

    return yes ?? false;
  }
}
