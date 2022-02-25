import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// TODO Renamed to Slice.topLeft etc - renamed each slice enum to opposite of what it was. Like a slice of pizza, but you get half. These enums say which half e.g. left or right half, or whole for a normal, complete cube.
/// Like a slice of pizza, but you get half.
/// These enums say which half e.g. left or right half,
/// or whole for a normal, complete cube.
/// The values are go around anti clockwise from the left.
/// TODO rename to topLeft, bottomRight
enum Slice {
  // 0 center
  whole,
  // 1 right
  r,
  // 2 up right
  ur,
  // 3 up left
  ul,
  // 4 left
  l,
  // 5 down left
  dl,
  // 6 down right
  dr,
}

void setSliceMode(Slice slice, BuildContext context) {
  final sliceModeNotifier =
      Provider.of<SliceModeNotifier>(context, listen: false);
  sliceModeNotifier.setSlice(slice);
}

class SliceModeNotifier extends ChangeNotifier {
  var _slice = Slice.dl;

  get slice => _slice;

  void setSlice(Slice slice) {
    _slice = slice;
    notifyListeners();
  }
}
