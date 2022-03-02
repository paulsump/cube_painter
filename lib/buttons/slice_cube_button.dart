import 'package:cube_painter/buttons/flat_hexagon_button.dart';
import 'package:cube_painter/cubes/slice_unit_cube.dart';
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
    return FlatHexagonButton(
        onPressed: () => _onPressed(slice, context),
        tip: 'For adding ${getSliceName(slice)} slices of cubes.',
        child: Transform.scale(
          scale: 21,
          child: SliceUnitCube(slice: slice),
        ));
  }
}

void _onPressed(Slice slice, BuildContext context) {
  final gestureModeNotifier =
      Provider.of<GestureModeNotifier>(context, listen: false);

  gestureModeNotifier.setSlice(slice);
  gestureModeNotifier.setMode(GestureMode.addSlice);

  Navigator.pop(context);
}
