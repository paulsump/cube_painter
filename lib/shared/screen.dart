import 'package:flutter/material.dart';

class Screen {
  static Size? _size;

  static double get width => size.width;
  static double get height => size.height;

  static Size get size => _size!;
  static Rect get rect => Offset.zero & size;

  // static double get aspect => size.width / size.height;

  // zoom
  // static double scale = 30;

  static void init(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final double safeAreaHeight = mediaQuery.padding.top;

    final size = mediaQuery.size;
    _size = Size(size.width, size.height - safeAreaHeight);
  }
}
