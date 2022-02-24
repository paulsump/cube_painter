import 'package:cube_painter/buttons/cube_button.dart';
import 'package:cube_painter/data/crop.dart';
import 'package:cube_painter/gesture_mode.dart';
import 'package:cube_painter/out.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const noWarn = out;

class CropCubeButton extends StatelessWidget {
  final Crop crop;

  const CropCubeButton({
    Key? key,
    required this.crop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentGestureMode = getGestureMode(context, listen: true);

    final Crop currentCrop =
        Provider.of<CropNotifier>(context, listen: true).crop;

    return CubeButton(
      height: 69,
      crop: crop,
      radioOn: currentCrop == crop && currentGestureMode == GestureMode.crop,
      onPressed: () {
        setGestureMode(GestureMode.crop, context);
        setCrop(crop, context);
      },
      tip:
          'Tap to add half a cube.  Cycle through the six options by pressing this button again.  You can change the position while you have your finger down.',
    );
  }
}
