import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Like a slice of pizza, but you get half.
/// These enums say which half e.g. left or right half,
/// or whole for a normal, complete cube.
/// The values are go around anti clockwise from the left.
/// TODO rename to topLeft, bottomRight
enum Slice {
  // 0
  whole,
  // 1
  left,
  // 2
  bottomLeft,
  // 3
  bottomRight,
  // 4
  right,
  // 5
  topRight,
  // 6
  topLeft,
}

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
