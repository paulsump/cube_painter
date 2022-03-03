import 'package:cube_painter/persisted/slice.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

enum GestureMode { brushAdd, brushErase, addSlice }

GestureMode getGestureMode(BuildContext context, {bool listen = false}) =>
    Provider.of<GestureModeNotifier>(context, listen: listen).gestureMode;

void setGestureMode(GestureMode mode, BuildContext context) {
  final gestureModeNotifier =
      Provider.of<GestureModeNotifier>(context, listen: false);

  gestureModeNotifier.setMode(mode);
}

class GestureModeNotifier extends ChangeNotifier {
  var _gestureMode = GestureMode.brushAdd;
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
