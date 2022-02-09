import 'package:cube_painter/model/crop_direction.dart';
import 'package:flutter/cupertino.dart';

//TODO PUT enum here

class CropNotifier extends ChangeNotifier {
  var _crop = Crop.dl;

  get crop => _crop;

  set crop(value) {
    _crop = value;
    notifyListeners();
  }

  void increment(int value, {int first = 1}) {
    int index = crop.index + value;

    final int last = Crop.values.length - 1;
    if (index < first) {
      index = last;
    } else if (index > last) {
      index = first;
    }

    crop = Crop.values[index];
  }
}
