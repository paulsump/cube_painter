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
}
