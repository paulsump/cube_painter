import 'package:cube_painter/transform/pan_zoom.dart';
import 'package:cube_painter/transform/screen.dart';
import 'package:flutter/material.dart';

/// the opposite
Offset screenToUnit(Offset offset, BuildContext context) {
  return (Offset(
              offset.dx, offset.dy - getScreen(context, listen: false).height) -
          getPanOffset(context, listen: false)) /
      getZoomScale(context);
}

/// translate to screen, then zoom
class UnitToScreen extends StatelessWidget {
  final Widget child;

  const UnitToScreen({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: getPanOffset(context, listen: true) +
          getScreen(context, listen: false).origin,
      child: Transform.scale(
        scale: getZoomScale(context),
        child: child,
      ),
    );
  }
}
