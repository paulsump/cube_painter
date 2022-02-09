import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

enum Mode { zoomPan, add, erase, crop }

Mode getMode(BuildContext context) {
  return Provider.of<ModeNotifier>(context, listen: false).mode;
}

class ModeNotifier extends ChangeNotifier {
  var _mode = Mode.add;

  get mode => _mode;

  set mode(value) {
    _mode = value;
    notifyListeners();
  }
}
