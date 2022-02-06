import 'package:flutter/material.dart';

class Screen {
  static Size? _size;

  static double get width => size.width;
  static double get height => size.height;

  static Size get size => _size!;
  static Rect get rect => Offset.zero & size;

  static void init(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final double safeAreaHeight = mediaQuery.padding.top;

    final size = mediaQuery.size;
    _size = Size(size.width, size.height - safeAreaHeight);
  }
}

// class ZoomPan extends ChangeNotifier {
//   static const _scaleStep = 0.1;
//
//   /// equates to the length of the side of each triangle in pixels
//   double scale = 30;
//
//   void increment(int increment) {
//     scale *= 1 + _scaleStep * increment;
//     notifyListeners();
//   }
// }
