// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'package:cube_painter/gestures/brush_maths.dart';
import 'package:cube_painter/persisted/position.dart';
import 'package:cube_painter/persisted/slice.dart';
import 'package:cube_painter/transform/unit_to_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

enum Brush { addLine, eraseLine, addSlice }

Brush getBrush(BuildContext context, {bool listen = false}) =>
    Provider.of<BrushNotifier>(context, listen: listen).brush;

void setBrush(Brush mode, BuildContext context) =>
    Provider.of<BrushNotifier>(context, listen: false).setBrush(mode);

void setAxesOrigin(Offset point, BuildContext context) {
  final Offset startUnit = screenToUnit(point, context);

  final brushMaths = BrushMaths();
  brushMaths.calcStartPosition(startUnit);

  Provider.of<BrushNotifier>(context, listen: false)
      .setAxesPosition(brushMaths.startPosition);
}

BrushNotifier getBrushNotifier(BuildContext context, {bool listen = false}) =>
    Provider.of<BrushNotifier>(context, listen: listen);

/// Access to which brush and slice we are currently using
class BrushNotifier extends ChangeNotifier {
  var _brush = Brush.addLine;

  var _slice = Slice.topRight;

  Position _axesPosition = Position.zero;

  get brush => _brush;

  get slice => _slice;

  get axesPosition => _axesPosition;

  void setBrush(Brush brush) {
    _brush = brush;
    notifyListeners();
  }

  void setSlice(Slice slice) {
    _slice = slice;
    notifyListeners();
  }

  void setAxesPosition(Position position) {
    _axesPosition = position;
    notifyListeners();
  }
}
