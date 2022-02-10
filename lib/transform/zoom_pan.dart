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

class PanZoomNotifier extends ChangeNotifier {
  static const _scaleStep = 0.1;

  double get scale => _scale;

  set scale(double value) {
    _scale = value;
    // out(_scale);
    notifyListeners();
  }

  /// equates to the length of the side of each triangle in pixels
  double _scale = 30;
}
