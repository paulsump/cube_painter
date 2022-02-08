import 'package:flutter/cupertino.dart';

enum Mode { add, erase, crop, zoomPan }

class ModeHolder extends ChangeNotifier {
  var mode = Mode.add;
}
