import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

class Screen {
  static Size? _size;

  // static double get width => size.width;
  // static double get height => size.height;

  static Size get size => _size!;
  static Rect get rect => Offset.zero & size;

  // static Offset get topRightGrid => Offset(size.width, -size.height);
  // static double get aspect => size.width / size.height;

  static void init(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final double safeAreaHeight = mediaQuery.padding.top;

    final size = mediaQuery.size;
    _size = Size(size.width, size.height - safeAreaHeight);
  }
}

// void clipAndZoom(Canvas canvas, BuildContext context) {
//   clip(canvas);
//   _zoom(canvas, context);
// }
//
// //TODO RENAME to fromScreen or toGrid?no
// Offset zoomOffset(Offset offset, BuildContext context) {
//   final zoom = Provider.of<Zoom>(context, listen: false);
//   return offset / zoom.scale;
// }
//
// // TODO rename?
// Offset toScreen(Offset offset, BuildContext context) {
//   final zoom = Provider.of<Zoom>(context, listen: false);
//   return offset * zoom.scale;
// }
//
// double zoomValue(double value, BuildContext context) {
//   final zoom = Provider.of<Zoom>(context, listen: false);
//   return value / zoom.scale;
// }
//
// void clip(Canvas canvas) => canvas.clipRect(Offset.zero & Screen.size);
//
// void _zoom(Canvas canvas, BuildContext context) {
//   final zoom = Provider.of<Zoom>(context, listen: false);
//   canvas.scale(zoom.scale, zoom.scale);
// }
//
// class Zoom extends ChangeNotifier {
//   static const _scaleStep = 0.1;
//
//   /// equates to the length of the side of each triangle in pixels
//   double scale = 30;
//
//   void increment(int increment) {
//     scale *= 1 + _scaleStep * increment;
//     notifyListeners();
//   }
// }
