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
  screen._setData(context, constraints);
}

// void clip(Canvas canvas, BuildContext context) =>
//     canvas.clipRect(getScreen(context, listen: false).rect);

class ScreenNotifier extends ChangeNotifier {
  late Size _size;

  late Offset _center;

  late EdgeInsets safe;

  double get width => _size.width;

  double get height => _size.height;

  /// used as the origin for the transform
  Offset get center => _center;

  double get aspect => width / height;
  // bool get landscape => width > height;

  void _setData(BuildContext context, BoxConstraints constraints) {
    final media = MediaQuery.of(context);

    safe = media.padding;
    final safeWidth = safe.left + safe.right;
    final safeHeight = safe.top + safe.bottom;

    final double w = constraints.maxWidth;
    final double h = constraints.maxHeight;

    _size = Size(w - safeWidth, h - safeHeight);
    _center = Offset(width, height) / 2;

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      notifyListeners();
    });
  }
}
