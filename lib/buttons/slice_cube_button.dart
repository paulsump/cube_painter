// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'package:cube_painter/buttons/flat_hexagon_button.dart';
import 'package:cube_painter/cubes/slice_unit_cube.dart';
import 'package:cube_painter/gestures/brush.dart';
import 'package:cube_painter/persisted/slice.dart';
import 'package:cube_painter/transform/screen_adjust.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// A button with a sliced cube on it.
/// For the [SlicesMenu].
class SliceCubeButton extends StatelessWidget {
  const SliceCubeButton({Key? key, required this.slice}) : super(key: key);

  final Slice slice;

  @override
  Widget build(BuildContext context) {
    return Align(
      heightFactor: 0.774,
      child: FlatHexagonButton(
          onPressed: () => _onPressed(slice, context),
          tip:
          'Drag on the canvas\nto move an\nanimating cube${slice == Slice.whole ? '' : ' slice'}.\n\nThen release to place it.',
          child: Transform.scale(
            scale: screenAdjustButtonChildScale(context),
            child: SliceUnitCube(slice: slice),
          )),
    );
  }
}

void _onPressed(Slice slice, BuildContext context) {
  final brushNotifier = Provider.of<BrushNotifier>(context, listen: false);

  brushNotifier.setSlice(slice);
  brushNotifier.setBrush(Brush.addSlice);

  Navigator.pop(context);
}
