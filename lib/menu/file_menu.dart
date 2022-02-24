import 'package:cube_painter/alert.dart';
import 'package:cube_painter/app_icons.dart';
import 'package:cube_painter/buttons/thumbnail.dart';
import 'package:cube_painter/colors.dart';
import 'package:cube_painter/data/cube_group.dart';
import 'package:cube_painter/menu/file_menu_text_item.dart';
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

    pop(VoidCallback funk) => () {
          funk();
          Navigator.pop(context);
        };

    final items = <TextItem>[
      TextItem(
        text: 'New',
        tip: 'Create a new cube group',
        icon: docNew,
        iconSize: appIconSize,
        // TODO create new persisted file,
        // so as not to overwrite the current one
        //TODO alert('are you sure,save current file?');
        callback: pop(cubeGroupNotifier.createNewFile),
      ),
      TextItem(
        text: 'Save',
        tip: 'Save the current cube group',
        icon: Icons.save,
        iconSize: iconSize,
        callback: pop(cubeGroupNotifier.saveFile),
        enabled: cubeGroupNotifier.modified,
      ),
      TextItem(
        text: 'Save a copy',
        tip:
            'Save the current cube group in a new file and start using that group',
        icon: copy,
        iconSize: appIconSize,
        callback: pop(cubeGroupNotifier.saveACopyFile),
      ),
      TextItem(
        text: 'Delete',
        tip:
            'Delete the current file. The next file is loaded or a new blank one is created.',
        icon: Icons.delete,
        iconSize: iconSize,
        callback: _deleteCurrentFile,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) => Drawer(
        // child: Container(
        // color: backgroundColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(height: 10.0 + MediaQuery.of(context).padding.top),
            for (TextItem item in items) FileMenuTextItem(item: item),
            const Divider(),
            const Padding(
              padding: EdgeInsets.only(left: 16),
              // FIX difference in fontWeight
              child: Text('Open...',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            for (MapEntry entry in cubeGroupNotifier.cubeGroupEntries)
              Tooltip(
                message: 'Load this cube group',
                child: TextButton(
                  onPressed: () => _loadFile(filePath: entry.key),
                  child: Thumbnail(cubeGroup: entry.value),
                ),
              ),
            const Divider(),
            // TODO JUST remove this loadSamples option
            FileMenuTextItem(
              item: TextItem(
                //TODO Re word 'Load Samples' - could be seen as 'open samples'
                text: 'Show Samples...',
                tip: 'Load the example files',
                icon: Icons.download_sharp,
                //menu_open_sharp,
                iconSize: iconSize,
                callback: () {
                  cubeGroupNotifier.loadSamples();
                  setState(() {});
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _loadFile({required String filePath}) async {
    final cubeGroupNotifier = getCubeGroupNotifier(context);

    if (!cubeGroupNotifier.modified || await _askLoad()) {
      cubeGroupNotifier.loadFile(filePath: filePath);
      setState(() {});
    }
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
      title: "Delete",
      content: "Delete current file?",
      yesCancelOnly: true,
    );
  }

  Future<bool> _askLoad() async {
    return await _askYesNoOrCancel(
        title: "Load",
        content: "Save the current changes?",
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
