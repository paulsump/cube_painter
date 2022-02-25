import 'package:cube_painter/buttons/hexagon_elevated_button.dart';
import 'package:cube_painter/colors.dart';
import 'package:flutter/material.dart';

class OpenFileMenuButton extends StatelessWidget {
  const OpenFileMenuButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HexagonElevatedButton(
      height: 66,
      child: Icon(
        Icons.folder_sharp,
        color: enabledIconColor,
        size: iconSize,
      ),
      onPressed: Scaffold.of(context).openDrawer,
      tip:
          'Open the side menu.  You can also get this menu by swiping from the left.',
    );
  }
}
