import 'package:cube_painter/buttons/hexagon_border.dart';
import 'package:cube_painter/buttons/thumbnail.dart';
import 'package:cube_painter/hue.dart';
import 'package:cube_painter/persisted/painting.dart';
import 'package:cube_painter/transform/position_to_unit.dart';
import 'package:cube_painter/transform/screen_size.dart';
import 'package:flutter/material.dart';

/// A flat transparent button with a thumbnail on it.
/// Has a hexagon border.
/// Used on the [PaintingsMenu].
class ThumbnailButton extends StatelessWidget {
  const ThumbnailButton({
    Key? key,
    required this.onPressed,
    required this.painting,
    required this.tip,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final Painting painting;

  final String tip;

  @override
  Widget build(BuildContext context) {
    final double height = screenAdjust(0.531, context);

    return Tooltip(
      message: tip,
      child: SizedBox(
        width: root3over2 * height,
        height: height,
        child: TextButton(
          onPressed: onPressed,
          child: Transform.scale(
            scale: height * 0.55,
            child: Thumbnail.useTransform(painting: painting),
          ),
          style: ButtonStyle(
            shape: hexagonBorderShape,
            overlayColor:
                MaterialStateColor.resolveWith((states) => Hue.button),
            backgroundColor:
                MaterialStateProperty.all(Hue.paintingsMenuButtons),
          ),
        ),
      ),
    );
  }
}
