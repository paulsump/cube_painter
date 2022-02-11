import 'package:cube_painter/out.dart';
import 'package:flutter/cupertino.dart';
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

// void clip(Canvas canvas, BuildContext context) =>
//     canvas.clipRect(getScreen(context, listen: false).rect);

class ScreenNotifier extends ChangeNotifier {
  Size? _size;
  Offset _origin = Offset.zero;

  double get _width => _size!.width;

  double get height => _size!.height;

  Offset get origin => _origin;

  void init(BuildContext context) {
    final media = MediaQuery.of(context);

    final pad = media.padding;
    final double safeAreaHeight = pad.top + pad.bottom;

    final Size newSize = media.size;

    final double x = newSize.width;
    final double y = newSize.height;

    _size = Size(x, y - safeAreaHeight);
    _origin = Offset(_width, height) / 2;

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      notifyListeners();
    });
  }
}
