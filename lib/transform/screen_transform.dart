import 'package:cube_painter/out.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const noWarn = out;

double getZoomScale(BuildContext context) {
  final zoom = Provider.of<ZoomPan>(context, listen: false);
  return zoom.scale;
}

//TODO test?
Offset screenToUnit(Offset offset, BuildContext context) {
  return Offset(offset.dx, offset.dy - Screen.height) / getZoomScale(context);
}

void clip(Canvas canvas) => canvas.clipRect(Screen.rect);

// TODO Rename.
// Can't remove by putting in Transformed due to screenToUnit() needing it
class Screen {
  static Size? _size;

  static double get width => size.width;

  static double get height => size.height;

  static Size get size => _size!;

  static Rect get rect => Offset.zero & size;

  static Offset get origin => Offset(0, height);

  static void init(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final pad = mediaQuery.padding;
    final double safeAreaHeight = pad.top + pad.bottom;

    final size = mediaQuery.size;
    _size = Size(size.width, size.height - safeAreaHeight);
  }
}

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
