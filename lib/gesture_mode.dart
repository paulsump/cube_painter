import 'package:cube_painter/data/slice.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

enum GestureMode { panZoom, addWhole, erase, addSlice }

GestureMode getGestureMode(BuildContext context, {bool listen = false}) =>
    Provider.of<GestureModeNotifier>(context, listen: listen).gestureMode;

void setGestureMode(GestureMode mode, BuildContext context) {}

class GestureModeNotifier extends ChangeNotifier {
  var _gestureMode = GestureMode.addWhole;
  var _slice = Slice.topRight;

  get gestureMode => _gestureMode;

  get slice => _slice;

  void setMode(GestureMode gestureMode) {
    _gestureMode = gestureMode;
    notifyListeners();
  }

  void setSlice(Slice slice) {
    _slice = slice;
    notifyListeners();
  }
}
