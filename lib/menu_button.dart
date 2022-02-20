import 'package:cube_painter/cube_button.dart';
import 'package:cube_painter/data/crop.dart';
import 'package:cube_painter/gesture_mode.dart';
import 'package:cube_painter/out.dart';
import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  final IconData icon;

  final Crop crop;

  const MenuButton({
    Key? key,
    required this.crop,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Transform.scale(
    //   scale: 21,
    //   child: CropUnitCube(crop: crop),
    // ),
    final mode = getGestureMode(context, listen: true);

    return CubeButton(
      radioOn: mode == crop,
      icon: Icons.add,
      onPressed: () {
        setGestureMode(GestureMode.crop, context);
        setCrop(crop, context);
        out(crop);
        Navigator.pop(context);
      },
      tip:
          'Tap or drag on the canvas to add a row of cubes. You can change the direction while you drag.',
    );
  }
}
