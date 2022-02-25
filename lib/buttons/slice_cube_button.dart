import 'package:cube_painter/buttons/cube_button.dart';
import 'package:cube_painter/data/slice.dart';
import 'package:cube_painter/gesture_mode.dart';
import 'package:cube_painter/out.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const noWarn = out;

class SliceCubeButton extends StatelessWidget {
  final Slice slice;

  const SliceCubeButton({
    Key? key,
    required this.slice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gestureModeNotifier =
        Provider.of<GestureModeNotifier>(context, listen: true);

    final GestureMode currentGestureMode = gestureModeNotifier.gestureMode;
    final Slice currentSlice = gestureModeNotifier.slice;

    return CubeButton(
      slice: slice,
      radioOn: currentSlice == slice && currentGestureMode == GestureMode.slice,
      onPressed: () {
        setGestureMode(GestureMode.slice, context);
        setSliceMode(slice, context);
        Navigator.pop(context);
      },
      tip: 'For adding ${getSliceName(slice)} slices of cubes.',
    );
  }
}
