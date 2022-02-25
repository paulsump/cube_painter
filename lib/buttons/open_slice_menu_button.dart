import 'package:cube_painter/buttons/slice_cube_button.dart';
import 'package:cube_painter/data/slice.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OpenSliceMenuButton extends StatelessWidget {
  const OpenSliceMenuButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Slice currentSlice =
        Provider.of<SliceModeNotifier>(context, listen: true).slice;

    return SliceCubeButton(
      slice: currentSlice,
      onPressed: Scaffold.of(context).openEndDrawer,
      tip: 'Open the slices menu',
    );
  }
}
