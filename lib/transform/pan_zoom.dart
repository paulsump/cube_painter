import 'package:cube_painter/out.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const noWarn = out;

double getZoomScale(BuildContext context) {
  final zoom = Provider.of<PanZoomNotifier>(context, listen: false);
  return zoom.scale;
}

void setZoomScale(BuildContext context, double scale) {
  final zoom = Provider.of<PanZoomNotifier>(context, listen: false);
  zoom.scale = scale;
}

Offset getPanOffset(BuildContext context) {
  final zoom = Provider.of<PanZoomNotifier>(context, listen: false);
  return zoom.offset;
}

void setPanOffset(BuildContext context, Offset offset) {
  final zoom = Provider.of<PanZoomNotifier>(context, listen: false);
  zoom.offset = offset;
}

class PanZoomNotifier extends ChangeNotifier {
  /// equates to the length of the side of each triangle in pixels
  double _scale = 30;

  Offset _offset = Offset.zero;

  double get scale => _scale;

  set scale(double value) {
    _scale = value;
    notifyListeners();
  }

  Offset get offset => _offset;

  set offset(Offset value) {
    _offset = value;
    // out(value);
    notifyListeners();
  }
}
