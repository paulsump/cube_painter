import 'package:cube_painter/buttons/hexagon_elevated_button.dart';
import 'package:cube_painter/buttons/slice_cube_button.dart';
import 'package:cube_painter/colors.dart';
import 'package:cube_painter/data/slice.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// TODO split into two classes
class OpenMenuButton extends StatelessWidget {
  final bool endDrawer;

  const OpenMenuButton({Key? key, required this.endDrawer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //TODO REMOVE endDrawer
    final scaffold = Scaffold.of(context);
    final Slice currentCrop =
        Provider.of<SliceModeNotifier>(context, listen: true).crop;

    return endDrawer
        ? CropCubeButton(
            crop: currentCrop,
            onPressed: Scaffold.of(context).openEndDrawer,
          )
        : HexagonElevatedButton(
            height: 66,
            child: Icon(
              endDrawer ? Icons.brush_sharp : Icons.folder_sharp,
              color: enabledIconColor,
              size: iconSize,
            ),
            onPressed: endDrawer ? scaffold.openEndDrawer : scaffold.openDrawer,
            tip:
                'Open the side menu.  You can also get this menu by swiping from the left.',
          );
  }
}
