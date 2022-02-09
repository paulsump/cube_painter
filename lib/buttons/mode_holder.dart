import 'package:flutter/cupertino.dart';

enum Mode { zoomPan, add, erase, crop }

class ModeHolder extends ChangeNotifier {
  var _mode = Mode.add;

  get mode => _mode;

  set mode(value) {
    _mode = value;
    notifyListeners();
  }
}
