import 'package:cube_painter/persisted/slice.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

enum Brush { addLine, eraseLine, addSlice }

Brush getBrush(BuildContext context, {bool listen = false}) =>
    Provider.of<BrushNotifier>(context, listen: listen).brush;

void setBrush(Brush mode, BuildContext context) =>
    Provider.of<BrushNotifier>(context, listen: false).setBrush(mode);

/// Access to which brush and slice we are currently using
class BrushNotifier extends ChangeNotifier {
  var _brush = Brush.addLine;

  var _slice = Slice.topRight;

  get brush => _brush;

  get slice => _slice;

  void setBrush(Brush brush) {
    _brush = brush;
    notifyListeners();
  }

  void setSlice(Slice slice) {
    _slice = slice;
    notifyListeners();
  }
}
