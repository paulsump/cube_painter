import 'package:cube_painter/buttons/hexagon_button.dart';
import 'package:cube_painter/buttons/thumbnail.dart';
import 'package:cube_painter/data/cube_group.dart';
import 'package:cube_painter/menu/file_menu_text_item.dart';
import 'package:cube_painter/out.dart';
import 'package:flutter/material.dart';

const noWarn = out;

class FileMenu extends StatelessWidget {
  const FileMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubeGroupNotifier = getCubeGroupNotifier(context);

    final items = <TextItem>[
      TextItem(
        text: 'New',
        tip: 'Create a new cube group',
        icon: Icons.star,
        // TODO create new persisted file,
        // so as not to overwrite the current one
        //TODO alert('are you sure,save current file?');
        callback: cubeGroupNotifier.createNewFile,
      ),
      TextItem(
        text: 'Save',
        tip: 'Save the current cube group',
        icon: Icons.save,
        callback: cubeGroupNotifier.saveFile,
        enabled: cubeGroupNotifier.canSave,
      ),
      TextItem(
        text: 'Save a copy',
        tip:
            'Save the current cube group in a new file and start using that group',
        icon: Icons.copy_sharp,
        callback: cubeGroupNotifier.saveACopyFile,
      ),
      TextItem(
        text: 'Delete',
        tip:
            'Delete the current file. After deleting, the next file is loaded or a new blank one is created',
        icon: Icons.delete_forever_sharp,
        callback: cubeGroupNotifier.deleteFile,
        enabled: cubeGroupNotifier.canDelete,
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
              child: Text(
                'Open...',
                // style: TextStyle(fontStyle: FontStyle.,)
              ),
            ),
            for (MapEntry entry in cubeGroupNotifier.cubeGroupEntries)
              HexagonButton(
                child: Thumbnail(cubeGroup: entry.value),
                onPressed: () =>
                    cubeGroupNotifier.loadFile(filePath: entry.key),
                tip: "Load this cube group",
              ),
            const Divider(),
            FileMenuTextItem(
              item: TextItem(
                text: 'Load Samples',
                tip: 'Load the example files',
                icon: Icons.menu_open_sharp,
                callback: () => cubeGroupNotifier.loadSamples(notify: true),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
