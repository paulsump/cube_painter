import 'package:cube_painter/persisted/slice.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

enum Brush { addLine, eraseLine, addSlice }

Brush getGestureMode(BuildContext context, {bool listen = false}) =>
    Provider.of<GestureModeNotifier>(context, listen: listen).gestureMode;

void setGestureMode(Brush mode, BuildContext context) {
  final gestureModeNotifier =
      Provider.of<GestureModeNotifier>(context, listen: false);

  gestureModeNotifier.setMode(mode);
}

class GestureModeNotifier extends ChangeNotifier {
  var _gestureMode = Brush.addLine;
  var _slice = Slice.topRight;

  get gestureMode => _gestureMode;

  get slice => _slice;

  void setMode(Brush gestureMode) {
    _gestureMode = gestureMode;
    notifyListeners();
  }

  void setSlice(Slice slice) {
    _slice = slice;
    notifyListeners();
  }
}
