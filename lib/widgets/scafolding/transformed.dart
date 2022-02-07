import 'package:cube_painter/shared/screen_transform.dart';
import 'package:flutter/material.dart';

/// translate to screen, then zoom
/// TODO Coord - rename tor UnitToScreen
class Transformed extends StatelessWidget {
  final Widget child;

  const Transformed({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //TODO DO screen.init() here and remove screen class
    return Transform.translate(
      // offset: Offset(Screen.width/4,3*Screen.height/4) ,
      offset: Screen.origin,
      child: Transform.scale(
        // scale: getZoomScale(context) / 2,
        scale: getZoomScale(context),
        child: child,
      ),
    );
  }
}
