import 'package:cube_painter/out.dart';
import 'package:cube_painter/transform/pan_zoom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const noWarn = out;

ScreenNotifier getScreen(BuildContext context, {required bool listen}) {
  return Provider.of<ScreenNotifier>(context, listen: listen);
}

void initScreen(BuildContext context) {
  final screen = getScreen(context, listen: false);
  screen.init(context);
}

Offset screenToUnit(Offset offset, BuildContext context) {
  return Offset(
          offset.dx, offset.dy - getScreen(context, listen: false).height) /
      getZoomScale(context);
}

// void clip(Canvas canvas, BuildContext context) =>
//     canvas.clipRect(getScreen(context, listen: false).rect);

class ScreenNotifier extends ChangeNotifier {
  Size? _size;

  double get width => size.width;

  double get height => size.height;

  Size get size => _size!;

  Rect get rect => Offset.zero & size;

  Offset get origin => Offset(width, height) / 2;

  void init(BuildContext context) {
    final media = MediaQuery.of(context);

    final pad = media.padding;
    final double safeAreaHeight = pad.top + pad.bottom;

    final Size newSize = media.size;

    final double x = newSize.width;
    final double y = newSize.height;

    _size = Size(x, y - safeAreaHeight);

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      notifyListeners();
    });
  }
}
