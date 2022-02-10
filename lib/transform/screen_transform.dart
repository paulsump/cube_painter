import 'package:cube_painter/out.dart';
import 'package:cube_painter/transform/zoom_pan.dart';
import 'package:flutter/material.dart';

const noWarn = out;

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
    final media = MediaQuery.of(context);

    final pad = media.padding;
    final double safeAreaHeight = pad.top + pad.bottom;

    Size newSize = media.size;

    final double x = newSize.width;
    final double y = newSize.height;

//     if (media.orientation == Orientation.portrait) {
    newSize = Size(x, y - safeAreaHeight);
//     } else {
//       newSize = Size(y, x - safeAreaHeight);
// //      newSize = Size(y, y);
//     }

    out('sl');
    if (size != newSize) {
      assert(size.width != newSize.width || size.height != newSize.height);
      //TODO draw a rect or place a widget to see these bounds
      _size = newSize;
      out(size);
      //TODO notifyListeners();
    }
  }
}
