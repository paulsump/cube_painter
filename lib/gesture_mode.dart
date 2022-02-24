import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

enum GestureMode { panZoom, add, erase, crop }

GestureMode getGestureMode(BuildContext context, {bool listen = false}) =>
    Provider.of<GestureModeNotifier>(context, listen: listen).mode;

void setGestureMode(GestureMode mode, BuildContext context) {
  final gestureModeNotifier =
      Provider.of<GestureModeNotifier>(context, listen: false);

  gestureModeNotifier.setMode(mode);
}

class GestureModeNotifier extends ChangeNotifier {
  var _mode = GestureMode.add;

  get mode => _mode;

  void setMode(GestureMode mode) {
    _mode = mode;
    notifyListeners();
  }
}
