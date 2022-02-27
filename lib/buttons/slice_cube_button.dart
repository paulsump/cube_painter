import 'package:cube_painter/buttons/cube_button.dart';
import 'package:cube_painter/constants.dart';
import 'package:cube_painter/data/slice.dart';
import 'package:cube_painter/downloaded_icons.dart';
import 'package:cube_painter/gesture_mode.dart';
import 'package:cube_painter/out.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const noWarn = out;

/// For the [SlicesMenu].
/// A button with a sliced cube on it.
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
      radioOn:
          currentSlice == slice && currentGestureMode == GestureMode.addSlice,
      onPressed: () {
        gestureModeNotifier.setSlice(slice);

        gestureModeNotifier.setMode(GestureMode.addSlice);
        Navigator.pop(context);
      },
      tip: 'For adding ${getSliceName(slice)} slices of cubes.',
    );
  }
}

class OpenSliceMenuButton extends StatelessWidget {
  const OpenSliceMenuButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gestureModeNotifier =
        Provider.of<GestureModeNotifier>(context, listen: true);

    final Slice slice = gestureModeNotifier.slice;
    final GestureMode currentGestureMode = gestureModeNotifier.gestureMode;

    return CubeButton(
      slice: slice,
      radioOn: currentGestureMode == GestureMode.addSlice,
      icon: DownloadedIcons.plusOutline,
      iconSize: downloadedIconSize,
      onPressed: Scaffold.of(context).openEndDrawer,
      tip:
          'Tap on the canvas to add a cube slice.  Tap this button again to choose different slices.',
    );
  }
}
