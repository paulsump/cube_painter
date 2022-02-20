import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// The direction to crop a cube in is like the
/// normal vector to the slice line.
/// So it's sliced perpendicular to the cropping direction
/// anti clockwise from right
enum Crop {
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

void setCrop(Crop crop, BuildContext context) {
  final cropNotifier = Provider.of<CropNotifier>(context, listen: false);
  cropNotifier.setCrop(crop);
}

class CropNotifier extends ChangeNotifier {
  var _crop = Crop.dl;

  get crop => _crop;

  void increment(int value, {int first = 1}) {
    int index = crop.index + value;

    final int last = Crop.values.length - 1;
    if (index < first) {
      index = last;
    } else if (index > last) {
      index = first;
    }

    _crop = Crop.values[index];
    notifyListeners();
  }

  void setCrop(Crop crop) {
    _crop = crop;
    notifyListeners();
  }
}
