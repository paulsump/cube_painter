import 'package:cube_painter/alert.dart';
import 'package:cube_painter/app_icons.dart';
import 'package:cube_painter/buttons/hexagon_border.dart';
import 'package:cube_painter/buttons/thumbnail.dart';
import 'package:cube_painter/colors.dart';
import 'package:cube_painter/data/cube_group.dart';
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
    final cubeGroupNotifier = getCubeGroupNotifier(context);

    final items = <MenuItem>[
      MenuItem(
        tip: 'Create a new file',
        icon: docNew,
        iconSize: appIconSize,
        callback: _newFile,
      ),
      MenuItem(
        tip: 'Save the current file',
        icon: Icons.save,
        iconSize: iconSize,
        callback: _saveFile,
        enabled: cubeGroupNotifier.modified,
      ),
      MenuItem(
        tip: 'Create a copy of this file and load it.',
        icon: copy,
        iconSize: appIconSize,
        callback: _saveACopyFile,
      ),
      MenuItem(
        tip:
            'Delete the current file. The next file is loaded or a new blank one is created.',
        icon: Icons.delete,
        iconSize: iconSize,
        callback: _deleteCurrentFile,
      ),
    ];

    final borderSide = BorderSide(width: 1.0, color: buttonBorderColor);
    const double offsetX = 55;

    return LayoutBuilder(
      builder: (context, constraints) => Drawer(
        // child: Container(
        // color: backgroundColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(height: 10.0 + MediaQuery.of(context).padding.top),
            Row(
              children: [
                for (MenuItem item in items) FileMenuButton(item: item),
              ],
            ),
            const Divider(),
            for (int i = 0; i < cubeGroupNotifier.cubeGroupEntries.length; ++i)
              Transform.translate(
                offset: Offset(i % 2 == 0 ? -offsetX : offsetX, 0),
                child: Tooltip(
                  message: 'Load this file',
                  child: TextButton(
                    onPressed: () => _loadFile(
                        filePath: cubeGroupNotifier.cubeGroupEntries[i].key),
                    child: Thumbnail(
                        cubeGroup: cubeGroupNotifier.cubeGroupEntries[i].value),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        HexagonBorder(side: borderSide),
                      ),
                      overlayColor: MaterialStateColor.resolveWith(
                          (states) => buttonColor),
                    ),
                  ),
                ),
              ),
            const Divider(),
          ],
        ),
      ),
    );
  }

  void _newFile() async {
    final cubeGroupNotifier = getCubeGroupNotifier(context);

    if (!cubeGroupNotifier.modified ||
        await _askSaveCurrent(title: 'New File')) {
      cubeGroupNotifier.newFile();
      setState(() {});
    }
  }

  void _loadFile({required String filePath}) async {
    final cubeGroupNotifier = getCubeGroupNotifier(context);

    if (!cubeGroupNotifier.modified ||
        await _askSaveCurrent(title: 'Load File')) {
      cubeGroupNotifier.loadFile(filePath: filePath);
      setState(() {});
    }
  }

  void _saveFile() async {
    final cubeGroupNotifier = getCubeGroupNotifier(context);

    await cubeGroupNotifier.saveFile();
    setState(() {});
  }

  void _saveACopyFile() async {
    final cubeGroupNotifier = getCubeGroupNotifier(context);

    await cubeGroupNotifier.saveACopyFile();
    setState(() {});
  }

  void _deleteCurrentFile() async {
    final cubeGroupNotifier = getCubeGroupNotifier(context);
    _deleteFile(filePath: cubeGroupNotifier.currentFilePath);
  }

  void _deleteFile({required String filePath}) async {
    if (await _askDelete()) {
      final cubeGroupNotifier = getCubeGroupNotifier(context);

      await cubeGroupNotifier.deleteFile(filePath: filePath);
      setState(() {});
    }
  }

  Future<bool> _askDelete() async {
//TODO ideally display the thumbnail, so they can be sure.

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
          final cubeGroupNotifier = getCubeGroupNotifier(context);

          cubeGroupNotifier.saveFile();
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

    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
