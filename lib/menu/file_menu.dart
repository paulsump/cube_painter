import 'package:cube_painter/colors.dart';
import 'package:cube_painter/data/cube_group.dart';
import 'package:cube_painter/menu/file_menu_text_item.dart';
import 'package:cube_painter/menu/thumbnail.dart';
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
        text: 'Load',
        icon: Icons.file_open_sharp,
        callback: cubeGroupNotifier.load,
      ),
      TextItem(
        text: 'Save',
        icon: Icons.save,
        callback: cubeGroupNotifier.save,
      ),
      TextItem(
        text: 'Next Example',
        icon: Icons.forward,
        callback: cubeGroupNotifier.loadNextExample,
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
              FileMenuTextItem(
                  item: TextItem(
                text: 'New',
                icon: Icons.star,
                // TODO create new persisted file,
                // so as not to overwrite the current one
                //TODO alert('are you sure,save current file?');
                callback: cubeGroupNotifier.createPersisted,
              )),
              const Center(child: Text('Save Current:')),
              GeneratedThumb(cubeGroup: cubeGroupNotifier.cubeGroup),
              const Center(child: Text('Load from:')),
              for (String imagePath in cubeGroupNotifier.allImagePaths)
                ImageThumb(filePath: imagePath),
              for (TextItem item in items) FileMenuTextItem(item: item),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
