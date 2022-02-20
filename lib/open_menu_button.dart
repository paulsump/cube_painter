import 'package:cube_painter/buttons/hexagon_button.dart';
import 'package:cube_painter/colors.dart';
import 'package:cube_painter/cubes/cube_sides.dart';
import 'package:flutter/material.dart';

class OpenMenuButton extends StatelessWidget {
  const OpenMenuButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HexagonButton(
      height: 55,
      child: Icon(Icons.menu, color: getColor(Side.br)),
      onPressed: Scaffold.of(context).openDrawer,
      tip:
          'Open the side menu.  You can also get this menu by swiping from the left.',
    );
  }
}
