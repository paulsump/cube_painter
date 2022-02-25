import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// TODO FIX this comment when i change them all
/// The normal vector to the slice line.
/// So it's sliced perpendicular to the cr*pping direction
/// anti clockwise from right
/// TODO REname to Slice and SliceModeNotifier
/// TODO REname each to opposite of current
/// TODO rename to topLeft, bottomRight
enum Slice {
  // 0 center
  c,
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
