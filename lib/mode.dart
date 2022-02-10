import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

enum Mode { panZoom, add, erase, crop }

// TODO rename to BrushMode or GestureMode
Mode getMode(BuildContext context, {bool listen = false}) {
  return Provider.of<ModeNotifier>(context, listen: listen).mode;
}

class ModeNotifier extends ChangeNotifier {
  var _mode = Mode.add;

  get mode => _mode;

  set mode(value) {
    _mode = value;
    notifyListeners();
  }
}
