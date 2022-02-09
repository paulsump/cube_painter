import 'package:cube_painter/transform/screen_transform.dart';
import 'package:cube_painter/transform/zoom_pan.dart';
import 'package:flutter/material.dart';

/// translate to screen, then zoom
class UnitToScreen extends StatelessWidget {
  final Widget child;

  const UnitToScreen({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Screen.origin,
      child: Transform.scale(
        scale: getZoomScale(context),
        child: child,
      ),
    );
  }
}
