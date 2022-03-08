import 'package:cube_painter/persisted/position.dart';
import 'package:cube_painter/persisted/slice.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

enum Brush { addLine, eraseLine, addSlice }

Brush getBrush(BuildContext context, {bool listen = false}) =>
    Provider.of<BrushNotifier>(context, listen: listen).brush;

void setBrush(Brush mode, BuildContext context) =>
    Provider.of<BrushNotifier>(context, listen: false).setBrush(mode);

Position getBrushStartPosition(BuildContext context, {bool listen = false}) =>
    Provider.of<BrushNotifier>(context, listen: listen).startPosition;

void setBrushStartPosition(Position position, BuildContext context) =>
    Provider.of<BrushNotifier>(context, listen: false)
        .setStartPosition(position);

BrushNotifier getBrushNotifier(BuildContext context, {bool listen = false}) =>
    Provider.of<BrushNotifier>(context, listen: listen);

/// Access to which brush and slice we are currently using
class BrushNotifier extends ChangeNotifier {
  var _brush = Brush.addLine;

  var _slice = Slice.topRight;

  Position _startPosition = Position.zero;

  get brush => _brush;

  get slice => _slice;

  get startPosition => _startPosition;

  void setBrush(Brush brush) {
    _brush = brush;
    notifyListeners();
  }

  void setSlice(Slice slice) {
    _slice = slice;
    notifyListeners();
  }

  void setStartPosition(Position position) {
    _startPosition = position;
    notifyListeners();
  }
}
