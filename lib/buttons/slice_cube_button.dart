import 'package:cube_painter/buttons/cube_button.dart';
import 'package:cube_painter/data/slice.dart';
import 'package:cube_painter/gesture_mode.dart';
import 'package:cube_painter/out.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const noWarn = out;

// TODO mabybe split into two classes , one with onPressed
class SliceCubeButton extends StatelessWidget {
  final Slice slice;
  final VoidCallback? onPressed;

  const SliceCubeButton({
    Key? key,
    required this.slice,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentGestureMode = getGestureMode(context, listen: true);

    final Slice currentSlice =
        Provider.of<SliceModeNotifier>(context, listen: true).slice;

    return CubeButton(
      height: 69,
      slice: slice,
      radioOn: currentSlice == slice && currentGestureMode == GestureMode.slice,
      onPressed: onPressed ??
          () {
            setGestureMode(GestureMode.slice, context);
            setSliceMode(slice, context);
            Navigator.pop(context);
          },
      tip: 'For adding ${getSliceName(slice)} slices of cubes.',
    );
  }
}
