import 'package:cube_painter/buttons/cube_button.dart';
import 'package:cube_painter/data/slice.dart';
import 'package:cube_painter/gesture_mode.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OpenSliceMenuButton extends StatelessWidget {
  const OpenSliceMenuButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Slice currentSlice =
        Provider.of<GestureModeNotifier>(context, listen: true).slice;

    return _SliceCubeButton(
      slice: currentSlice,
      onPressed: Scaffold.of(context).openEndDrawer,
      tip: 'Open the slices menu',
    );
  }
}

class _SliceCubeButton extends StatelessWidget {
  final Slice slice;
  final VoidCallback onPressed;
  final String tip;

  const _SliceCubeButton({
    Key? key,
    required this.slice,
    required this.onPressed,
    required this.tip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gestureModeNotifier =
        Provider.of<GestureModeNotifier>(context, listen: true);

    final GestureMode currentGestureMode = gestureModeNotifier.gestureMode;
    final Slice currentSlice = gestureModeNotifier.slice;

    return CubeButton(
      height: 69,
      slice: slice,
      radioOn:
          currentSlice == slice && currentGestureMode == GestureMode.addSlice,
      onPressed: onPressed,
      tip: tip,
    );
  }
}
