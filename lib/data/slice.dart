import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Like a slice of pizza, but you get half.
/// These enums say which half e.g. left or right half,
/// or whole for a normal, complete cube.
/// The values are go around anti clockwise from the left.
enum Slice { whole, left, bottomLeft, bottomRight, right, topRight, topLeft }

String getSliceName(Slice slice) => slice.toString().split('.').last;

void setSliceMode(Slice slice, BuildContext context) {
  final sliceModeNotifier =
      Provider.of<SliceModeNotifier>(context, listen: false);
  sliceModeNotifier.setSlice(slice);
}

class SliceModeNotifier extends ChangeNotifier {
  var _slice = Slice.topRight;

  get slice => _slice;

  void setSlice(Slice slice) {
    _slice = slice;
    notifyListeners();
  }
}
