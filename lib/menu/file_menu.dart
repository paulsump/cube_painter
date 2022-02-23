import 'package:cube_painter/alert.dart';
import 'package:cube_painter/buttons/hexagon_button.dart';
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
        icon: Icons.star,
        // TODO create new persisted file,
        // so as not to overwrite the current one
        //TODO alert('are you sure,save current file?');
        callback: pop(cubeGroupNotifier.createNewFile),
      ),
      TextItem(
        text: 'Save',
        tip: 'Save the current cube group',
        icon: Icons.save,
        callback: pop(cubeGroupNotifier.saveFile),
        enabled: cubeGroupNotifier.canSave,
      ),
      TextItem(
        text: 'Save a copy',
        tip:
            'Save the current cube group in a new file and start using that group',
        icon: Icons.copy_sharp,
        callback: pop(cubeGroupNotifier.saveACopyFile),
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
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Text('Delete'),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Text('Open'),
                  ),
                ]),
            for (MapEntry entry in cubeGroupNotifier.cubeGroupEntries)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  HexagonButton(
                    height: 66,
                    child: Icon(
                      Icons.delete_forever_sharp,
                      size: iconSize,
                    ),
                    tip:
                        'Delete the current file. After deleting, the next file is loaded or a new blank one is created',
                    onPressed: () => _deleteFile(filePath: entry.key),
                  ),
                  Thumbnail(cubeGroup: entry.value),
                  HexagonButton(
                    height: 66,
                    child: Icon(
                      Icons.open_in_new,
                      size: iconSize,
                    ),
                    onPressed: () => _loadFile(filePath: entry.key),
                    tip: "Load this cube group",
                  ),
                ],
              ),
            const Divider(),
            FileMenuTextItem(
              item: TextItem(
                text: 'Load Samples',
                tip: 'Load the example files',
                icon: Icons.menu_open_sharp,
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

    if (!cubeGroupNotifier.modified || await _userConfirmLoad()) {
      cubeGroupNotifier.loadFile(filePath: filePath);
    }
  }

  void _deleteFile({required String filePath}) async {
    if (await _userConfirmDelete()) {
      out(1);
      // final cubeGroupNotifier = getCubeGroupNotifier(context);
      //
      // await cubeGroupNotifier.deleteFile(filePath: filePath);
      // setState(() {});
    }
    out('don');
  }

  Future<bool> _userConfirmDelete() {
    return _saved();
  }

  Future<bool> _userConfirmLoad() {
    return _saved();
  }

  Future<bool> _saved() async {
    // if (!modified) {
    //   return true;
    // }
    return await _showDialog();
  }

  Future<bool> _showDialog() async {
    final alert = Alert(
      title: "Delete",
      content: "Save the current file?",
      yesCallBack: () {
        // TODO Save
        out('save');
        Navigator.of(context).pop(true);
//TODO return true
      },
      noCallBack: () {
        Navigator.of(context).pop(true);
//TODO return true
      },
      cancelCallBack: () {
        Navigator.of(context).pop(false);
//TODO return false
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
