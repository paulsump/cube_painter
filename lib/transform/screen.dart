import 'package:cube_painter/out.dart';
import 'package:cube_painter/transform/zoom_pan.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const noWarn = out;

ScreenNotifier getScreen(BuildContext context) {
  return Provider.of<ScreenNotifier>(context, listen: false);
}

//TODO test?
Offset screenToUnit(Offset offset, BuildContext context) {
  return Offset(offset.dx, offset.dy - getScreen(context).height) /
      getZoomScale(context);
}

void clip(Canvas canvas, BuildContext context) =>
    canvas.clipRect(getScreen(context).rect);

class ScreenNotifier extends ChangeNotifier {
  Size? _size;

  double get width => size.width;

  double get height => size.height;

  Size get size => _size!;

  Rect get rect => Offset.zero & size;

  Offset get origin => Offset(0, height);

  void init(BuildContext context) {
    final media = MediaQuery.of(context);

    final pad = media.padding;
    final double safeAreaHeight = pad.top + pad.bottom;

    final Size newSize = media.size;

    final double x = newSize.width;
    final double y = newSize.height;

    _size = Size(x, y - safeAreaHeight);
    //TODO NOtify
    // notifyListeners();
  }
}