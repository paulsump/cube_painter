import 'package:cube_painter/alert.dart';
import 'package:cube_painter/buttons/hexagon_border_button.dart';
import 'package:cube_painter/buttons/thumbnail.dart';
import 'package:cube_painter/data/sketch.dart';
import 'package:cube_painter/downloaded_icons.dart';
import 'package:cube_painter/menu/file_menu_button.dart';
import 'package:cube_painter/out.dart';
import 'package:flutter/material.dart';

const noWarn = out;

class FileMenu extends StatefulWidget {
  const FileMenu({Key? key}) : super(key: key);

  @override
  State<FileMenu> createState() => _FileMenuState();
}

class _FileMenuState extends State<FileMenu> {
  @override
  Widget build(BuildContext context) {
    final sketchBank = getSketchBank(context);

    final items = <MenuItem>[
      MenuItem(
        tip: 'Create a new file',
        icon: DownloadedIcons.docNew,
        iconSize: downloadedIconSize * 0.96,
        onPressed: _newFile,
      ),
      MenuItem(
        tip: 'Save the current file',
        icon: Icons.save,
        iconSize: normalIconSize,
        onPressed: _saveFile,
        enabled: sketchBank.modified,
      ),
      MenuItem(
        tip: 'Create a copy of this file and load it.',
        icon: DownloadedIcons.copy,
        iconSize: downloadedIconSize,
        onPressed: _saveACopyFile,
      ),
      MenuItem(
        tip:
            'Delete the current file. The next file is loaded or a new blank one is created.',
        icon: Icons.delete,
        iconSize: normalIconSize,
        onPressed: _deleteCurrentFile,
      ),
    ];

    const double offsetX = 55;
    const padY = SizedBox(height: 15.0);

    return LayoutBuilder(
      builder: (context, constraints) => Drawer(
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              padY,
              const Center(child: Text('File')),
              padY,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (MenuItem item in items) FileMenuButton(item: item),
                ],
              ),
              const SizedBox(height: 5.0),
              const Divider(),
              for (int i = 0; i < sketchBank.sketchEntries.length; ++i)
                Transform.translate(
                  offset: Offset(i % 2 == 0 ? -offsetX : offsetX, 0),
                  child: HexagonBorderButton(
                    tip: 'Load this file',
                    onPressed: () =>
                        _loadFile(filePath: sketchBank.sketchEntries[i].key),
                    child: Thumbnail(sketch: sketchBank.sketchEntries[i].value),
                  ),
                ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }

  void _newFile() async {
    final sketchBank = getSketchBank(context);

    if (!sketchBank.modified || await _askSaveCurrent(title: 'New File')) {
      sketchBank.newFile();
      setState(() {});
    }
  }

  void _loadFile({required String filePath}) async {
    final sketchBank = getSketchBank(context);

    if (!sketchBank.modified || await _askSaveCurrent(title: 'Load File')) {
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
    final sketchBank = getSketchBank(context);
    _deleteFile(filePath: sketchBank.currentFilePath);
  }

  void _deleteFile({required String filePath}) async {
    if (await _askDelete()) {
      final sketchBank = getSketchBank(context);

      await sketchBank.deleteFile(filePath: filePath);
      setState(() {});
    }
  }

  Future<bool> _askDelete() async {
    return await _askYesNoOrCancel(
      title: 'Delete',
      content: 'Delete current file?',
      yesCancelOnly: true,
    );
  }

  Future<bool> _askSaveCurrent({required String title}) async {
    return await _askYesNoOrCancel(
        title: title,
        content: 'Save the current changes?',
        yesCallBack: () {
          final sketchBank = getSketchBank(context);

          sketchBank.saveFile();
        });
  }

  Future<bool> _askYesNoOrCancel({
    required String title,
    required String content,
    VoidCallback? yesCallBack,
    bool yesCancelOnly = false,
  }) async {
    final alert = Alert(
      title: title,
      content: content,
      yesCallBack: () {
        yesCallBack?.call();
        Navigator.of(context).pop(true);
      },
      noCallBack: yesCancelOnly
          ? null
          : () {
              Navigator.of(context).pop(true);
            },
      cancelCallBack: () {
        Navigator.of(context).pop(false);
      },
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
