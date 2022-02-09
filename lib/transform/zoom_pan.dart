import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

double getZoomScale(BuildContext context) {
  final zoom = Provider.of<ZoomPanNotifier>(context, listen: false);
  return zoom.scale;
}

/// TODO set by gestures
class ZoomPanNotifier extends ChangeNotifier {
  static const _scaleStep = 0.1;

  /// equates to the length of the side of each triangle in pixels
  double scale = 30;

  ///TODO rename and use
  void increment(int increment) {
    scale *= 1 + _scaleStep * increment;
    notifyListeners();
  }
}
