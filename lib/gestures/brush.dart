import 'package:cube_painter/persisted/slice.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

enum Brush { addLine, eraseLine, addSlice }

Brush getBrush(BuildContext context, {bool listen = false}) =>
    Provider.of<BrushNotifier>(context, listen: listen).gestureMode;

void setBrush(Brush mode, BuildContext context) {
  final gestureModeNotifier =
      Provider.of<BrushNotifier>(context, listen: false);

  gestureModeNotifier.setMode(mode);
}

class BrushNotifier extends ChangeNotifier {
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
