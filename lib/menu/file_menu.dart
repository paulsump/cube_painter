import 'package:cube_painter/buttons/hexagon_button.dart';
import 'package:cube_painter/buttons/thumbnail.dart';
import 'package:cube_painter/colors.dart';
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
        callback: cubeGroupNotifier.createPersisted,
        // callback: cubeGroupNotifier.save,
      ),
      // TextItem(
      //   text: 'Load',
      //   icon: Icons.file_open_sharp,
      //   callback: cubeGroupNotifier.load,
      // ),
      TextItem(
        text: 'Save',
        tip: 'Save the current cube group',
        icon: Icons.save,
        callback: cubeGroupNotifier.save,
      ),
      TextItem(
        text: 'Save a copy',
        tip:
            'Save the current cube group in a new file and start using that group',
        icon: Icons.copy_sharp,
        callback: cubeGroupNotifier.saveACopy,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) => Drawer(
        child: Container(
          color: backgroundColor,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(height: 10.0 + MediaQuery.of(context).padding.top),
              for (TextItem item in items) FileMenuTextItem(item: item),
              const Divider(),
              const Text(
                'Load:',
                // style: TextStyle(fontStyle: FontStyle.,)
              ),
              for (CubeGroup cubeGroup in cubeGroupNotifier.cubeGroups)
                HexagonButton(
                  child: Thumbnail(cubeGroup: cubeGroup),
                  onPressed: () {
                    //TODO load file when press button

                    cubeGroupNotifier.load(filePath: '0.todo');
                  },
                  tip: "Load this cube group",
                ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
