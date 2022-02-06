import 'package:cube_painter/shared/screen_transform.dart';
import 'package:cube_painter/widgets/grid.dart';
import 'package:flutter/material.dart';

/// translate to screen, then zoom
class Transformed extends StatelessWidget {
  const Transformed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Screen.origin,
      child: Transform.scale(
        scale: getZoomScale(context),
        child: const Grid(),
      ),
    );
  }
}
