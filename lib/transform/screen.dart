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

  double _safeBottom = 0;

  EdgeInsets safe = const EdgeInsets.all(0.0);

  double get width => _size!.width;

  double get height => _size!.height;

  /// used as the origin for the transform
  Offset get center => _center;

  double get aspect => width / height;


  double get safeBottom => _safeBottom;

  void init(BuildContext context, BoxConstraints constraints) {
    final media = MediaQuery.of(context);

    final pad = media.padding;
    final safeWidth = pad.left + pad.right;
    final safeHeight = pad.top + pad.bottom;
    safe = pad;
    _safeBottom = pad.bottom;

    final double x = constraints.maxWidth;
    final double y = constraints.maxHeight;

    _size = Size(x - safeWidth, y - safeHeight);
    _center = Offset(width, height) / 2;

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      notifyListeners();
    });
  }
}
