import 'package:cube_painter/buttons/flat_hexagon_button.dart';
import 'package:cube_painter/cubes/slice_unit_cube.dart';
import 'package:cube_painter/gestures/brush.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/persisted/slice.dart';
import 'package:cube_painter/transform/screen_size.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const noWarn = out;

/// A button with a sliced cube on it.
/// For the [SlicesMenu].
class SliceCubeButton extends StatelessWidget {
  final Slice slice;

  const SliceCubeButton({Key? key, required this.slice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatHexagonButton(
        onPressed: () => _onPressed(slice, context),
        tip:
            'Drag on the canvas\nto move an\nanimating cube${slice == Slice.whole ? '' : ' slice'}.\n\nThen release to place it.',
        child: Transform.scale(
          scale: calcButtonChildScale(context),
          child: SliceUnitCube(slice: slice),
        ));
  }
}

void _onPressed(Slice slice, BuildContext context) {
  final gestureModeNotifier =
      Provider.of<BrushNotifier>(context, listen: false);

  gestureModeNotifier.setSlice(slice);
  gestureModeNotifier.setMode(Brush.addSlice);

  Navigator.pop(context);
}
