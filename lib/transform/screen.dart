import 'package:cube_painter/out.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const noWarn = out;

ScreenNotifier getScreen(BuildContext context, {required bool listen}) {
  return Provider.of<ScreenNotifier>(context, listen: listen);
}

void storeScreenSize(BuildContext context, BoxConstraints constraints) {
  final screen = getScreen(context, listen: false);
  screen.init(context, constraints);
}

// void clip(Canvas canvas, BuildContext context) =>
//     canvas.clipRect(getScreen(context, listen: false).rect);

class ScreenNotifier extends ChangeNotifier {
  Size? _size;
  Offset _center = Offset.zero;

  double get width => _size!.width;

  double get height => _size!.height;

  /// used as the origin for the transform
  Offset get center => _center;

  void init(BuildContext context, BoxConstraints constraints) {
    final media = MediaQuery.of(context);

    final pad = media.padding;
    final double safeAreaHeight = pad.top + pad.bottom;

    final double x = constraints.maxWidth;
    final double y = constraints.maxHeight;

    _size = Size(x, y - safeAreaHeight);
    _center = Offset(width, height) / 2;

      WidgetsBinding.instance!.addPostFrameCallback((_) {
        notifyListeners();
      });
  }
}
