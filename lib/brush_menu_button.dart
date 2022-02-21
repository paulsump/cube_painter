import 'package:cube_painter/cube_button.dart';
import 'package:cube_painter/data/crop.dart';
import 'package:cube_painter/gesture_mode.dart';
import 'package:cube_painter/out.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const noWarn = out;

class BrushMenuButton extends StatelessWidget {
  final Crop crop;
  final double offsetX;

  const BrushMenuButton({
    Key? key,
    required this.crop,
    required this.offsetX,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentGestureMode = getGestureMode(context, listen: true);

    final Crop currentCrop =
        Provider.of<CropNotifier>(context, listen: true).crop;

    return Transform.translate(
      offset: Offset(offsetX, 0),
      child: CubeButton(
        height: 69,
        crop: crop,
        radioOn:
            (currentCrop == crop && currentGestureMode == GestureMode.crop) ||
                (crop == Crop.c && currentGestureMode == GestureMode.add),
        // icon: Icons.add,
        onPressed: () {
          // if(mode!=GestureMode.crop){
          setGestureMode(
              crop == Crop.c ? GestureMode.add : GestureMode.crop, context);
          setCrop(crop, context);
          Navigator.pop(context);
        },
        tip: Crop.c == crop
            ? 'Tap or drag on the canvas to add a row of cubes. You can change the direction while you drag.'
            : 'Tap to add half a cube.  Cycle through the six options by pressing this button again.  You can change the position while you have your finger down.',
      ),
    );
  }
}
