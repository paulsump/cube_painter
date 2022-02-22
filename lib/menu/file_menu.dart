import 'package:cube_painter/colors.dart';
import 'package:cube_painter/cubes/thumbnail.dart';
import 'package:cube_painter/data/cube_group.dart';
import 'package:cube_painter/menu/menu_text_item.dart';
import 'package:cube_painter/menu/saved_thumbnail.dart';
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
              MenuTextItem(
                  item: TextItem(
                text: 'New',
                icon: Icons.star,
                // TODO create new persisted file,
                // so as not to overwrite the current one
                callback: cubeGroupNotifier.clear,
              )),
              const Center(child: Text('Save Current:')),
              Thumbnail(cubeGroup: cubeGroupNotifier.cubeGroup),
              const Center(child: Text('Load from:')),
              if (cubeGroupNotifier.currentName == 'triangle')
                const SavedThumbnail(fileName: 'triangle.png'),
              for (TextItem item in items) MenuTextItem(item: item),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
