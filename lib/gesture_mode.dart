import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

enum GestureMode { panZoom, add, erase, crop }

GestureMode getGestureMode(BuildContext context, {bool listen = false}) {
  return Provider.of<GestureModeNotifier>(context, listen: listen).mode;
}

void setGestureMode(GestureMode mode, BuildContext context) {
  final gestureModeNotifier =
      Provider.of<GestureModeNotifier>(context, listen: false);

  gestureModeNotifier.mode = mode;
}

class GestureModeNotifier extends ChangeNotifier {
  var _mode = GestureMode.panZoom;

  get mode => _mode;

  set mode(value) {
    _mode = value;
    notifyListeners();
  }
}
