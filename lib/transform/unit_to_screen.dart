import 'package:cube_painter/transform/pan_zoom.dart';
import 'package:cube_painter/transform/screen.dart';
import 'package:flutter/material.dart';

/// the opposite of UnitToScreen
Offset screenToUnit(Offset point, BuildContext context) =>
    (point - getScreenCenter(context) - getPanOffset(context, listen: false)) /
    getZoomScale(context);

/// translate to screen, then zoom
class UnitToScreen extends StatelessWidget {
  final Widget child;

  const UnitToScreen({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: getPanOffset(context, listen: true) + getScreenCenter(context),
      child: Transform.scale(
        scale: getZoomScale(context),
        child: child,
      ),
    );
  }
}
