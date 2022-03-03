import 'package:cube_painter/persisted/slice.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

enum Brush { addLine, eraseLine, addSlice }

Brush getBrush(BuildContext context, {bool listen = false}) =>
    Provider.of<BrushNotifier>(context, listen: listen).brush;

void setBrush(Brush mode, BuildContext context) {
  final brushNotifier = Provider.of<BrushNotifier>(context, listen: false);

  brushNotifier.setMode(mode);
}

class BrushNotifier extends ChangeNotifier {
  var _brush = Brush.addLine;
  var _slice = Slice.topRight;

  get brush => _brush;

  get slice => _slice;

  void setMode(Brush brush) {
    _brush = brush;
    notifyListeners();
  }

  void setSlice(Slice slice) {
    _slice = slice;
    notifyListeners();
  }
}
