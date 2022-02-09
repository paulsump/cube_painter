import 'package:flutter/material.dart';

/// TODO set by gestures
class ZoomPan extends ChangeNotifier {
  static const _scaleStep = 0.1;

  /// equates to the length of the side of each triangle in pixels
  double scale = 30;

  ///TODO rename and use
  void increment(int increment) {
    scale *= 1 + _scaleStep * increment;
    notifyListeners();
  }
}
