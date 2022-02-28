import 'package:cube_painter/buttons/hexagon_border.dart';
import 'package:cube_painter/buttons/thumbnail.dart';
import 'package:cube_painter/colors.dart';
import 'package:cube_painter/persisted/sketch.dart';
import 'package:flutter/material.dart';

/// A flat transparent button with a thumbnail on it.
/// Has a hexagon border.
/// Used on the [PaintingsMenu].
class ThumbnailButton extends StatelessWidget {
  final VoidCallback? onPressed;

  final String tip;

  final Sketch sketch;

  const ThumbnailButton({
    Key? key,
    required this.onPressed,
    required this.tip,
    required this.sketch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double height = 185;

    return Tooltip(
      message: tip,
      child: SizedBox(
        /// TODO Responsive to screen size- magic numbers
        height: height,
        child: TextButton(
          onPressed: onPressed,
          child: Transform.scale(
            scale: height * 0.6,
            child: Thumbnail(
              sketch: sketch,
              unitTransform: sketch.unitTransform,
            ),
          ),
          style: ButtonStyle(
            shape: hexagonBorderShape,
            overlayColor:
                MaterialStateColor.resolveWith((states) => buttonColor),
          ),
        ),
      ),
    );
  }
}
