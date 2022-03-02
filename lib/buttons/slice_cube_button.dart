import 'package:cube_painter/buttons/cube_button.dart';
import 'package:cube_painter/gesture_mode.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/persisted/slice.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const noWarn = out;

/// A button with a sliced cube on it.
/// For the [SlicesMenu].
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

    return CubeElevatedHexagonButton(
      slice: slice,
      isRadioOn:
          currentSlice == slice && currentGestureMode == GestureMode.addSlice,
      onPressed: () => _onPressed(context),
      tip: 'For adding ${getSliceName(slice)} slices of cubes.',
    );
  }

  void _onPressed(BuildContext context) {
    final gestureModeNotifier =
        Provider.of<GestureModeNotifier>(context, listen: false);

    gestureModeNotifier.setSlice(slice);
    gestureModeNotifier.setMode(GestureMode.addSlice);

    Navigator.pop(context);
  }
}
