import 'package:cube_painter/shared/out.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const noWarn = out;

double getZoomScale(BuildContext context) {
  final zoom = Provider.of<ZoomPan>(context, listen: false);
  return zoom.scale;
}

// TODO Rename or remove
class Screen {
  static Size? _size;

  static double get width => size.width;

  static double get height => size.height;

  static Size get size => _size!;

  static Rect get rect => Offset.zero & size;

  static Offset get origin => Offset(0, height);

  static void init(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final double safeAreaHeight =
        mediaQuery.padding.top + mediaQuery.padding.bottom;

    final size = mediaQuery.size;
    _size = Size(size.width, size.height - safeAreaHeight);
  }
}

/// TODO set by gestures
class ZoomPan extends ChangeNotifier {
  static const _scaleStep = 0.1;

  /// equates to the length of the side of each triangle in pixels
  double scale = 100;

  ///TODO rename and use
  void increment(int increment) {
    scale *= 1 + _scaleStep * increment;
    notifyListeners();
  }
}
