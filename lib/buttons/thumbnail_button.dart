import 'package:cube_painter/buttons/hexagon_border.dart';
import 'package:cube_painter/buttons/thumbnail.dart';
import 'package:cube_painter/colors.dart';
import 'package:cube_painter/persisted/painting.dart';
import 'package:flutter/material.dart';

/// A flat transparent button with a thumbnail on it.
/// Has a hexagon border.
/// Used on the [PaintingsMenu].
class ThumbnailButton extends StatelessWidget {
  final VoidCallback? onPressed;

  final String tip;

  final Painting painting;

  const ThumbnailButton({
    Key? key,
    required this.onPressed,
    required this.tip,
    required this.painting,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// TODO Responsive to screen size- magic numbers
    const double height = 185;

    return Tooltip(
      message: tip,
      child: SizedBox(
        height: height,
        child: TextButton(
          onPressed: onPressed,
          child: Transform.scale(
            scale: height * 0.6,
            child: Thumbnail.useTransform(painting: painting),
          ),
          style: ButtonStyle(
            shape: hexagonBorderShape,
            overlayColor:
                MaterialStateColor.resolveWith((states) => buttonColor),
            backgroundColor:
                MaterialStateProperty.all(paintingsMenuButtonsColor),
          ),
        ),
      ),
    );
  }
}
