import 'package:cube_painter/gestures/pan_zoom.dart';
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

/// move the horizon less, to fake 3d
/// translate to screen, then zoom
class UnitToScreenHorizon extends StatelessWidget {
  final Widget child;

  const UnitToScreenHorizon({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      /// TODO Responsive to screen size- magic numbers
      offset:
          getPanOffset(context, listen: true) / 1.2 + getScreenCenter(context),
      child: Transform.scale(
        /// TODO Responsive to screen size- magic numbers
        scale: 30 * getZoomScale(context),
        child: child,
      ),
    );
  }
}
