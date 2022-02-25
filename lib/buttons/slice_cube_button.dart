import 'package:cube_painter/buttons/cube_button.dart';
import 'package:cube_painter/data/slice.dart';
import 'package:cube_painter/gesture_mode.dart';
import 'package:cube_painter/out.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const noWarn = out;

// TODO mabybe split into two classes , one with onPressed
class CropCubeButton extends StatelessWidget {
  final Slice crop;
  final VoidCallback? onPressed;

  const CropCubeButton({
    Key? key,
    required this.crop,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentGestureMode = getGestureMode(context, listen: true);

    final Slice currentCrop =
        Provider.of<SliceModeNotifier>(context, listen: true).crop;

    return CubeButton(
      height: 69,
      crop: crop,
      radioOn: currentCrop == crop && currentGestureMode == GestureMode.slice,
      onPressed: onPressed ??
          () {
            setGestureMode(GestureMode.slice, context);
            setCrop(crop, context);
            Navigator.pop(context);
          },
      tip:
          'Tap to add half a cube.  Cycle through the six options by pressing this button again.  You can change the position while you have your finger down.',
    );
  }
}
