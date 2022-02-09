import 'package:cube_painter/rendering/colors.dart';
import 'package:cube_painter/rendering/side.dart';
import 'package:flutter/cupertino.dart';

enum Mode { zoomPan, add, erase, crop }

Color? getModeColor(Mode mode) {
  switch (mode) {
    case Mode.zoomPan:
      return null;
    case Mode.add:
      return getColor(Side.bl);
    case Mode.erase:
      return getColor(Side.t);
    case Mode.crop:
      return getColor(Side.br);
  }
}

class ModeNotifier extends ChangeNotifier {
  var _mode = Mode.add;

  get mode => _mode;

  set mode(value) {
    _mode = value;
    notifyListeners();
  }

  Color? get color => getModeColor(mode);
}
