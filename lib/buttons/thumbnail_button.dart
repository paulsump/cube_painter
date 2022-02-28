import 'package:cube_painter/buttons/hexagon_border.dart';
import 'package:cube_painter/colors.dart';
import 'package:flutter/material.dart';

/// A flat transparent button with a thumbnail on it.
/// Has a hexagon border.
/// Used on the [PaintingsMenu].
class ThumbnailButton extends StatelessWidget {
  final VoidCallback? onPressed;

  final Widget child;
  final String tip;

  const ThumbnailButton({
    Key? key,
    required this.child,
    required this.onPressed,
    required this.tip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Tooltip(
      message: tip,
      child: TextButton(
        onPressed: onPressed,
        child: child,
        style: ButtonStyle(
          shape: hexagonBorderShape,
          overlayColor: MaterialStateColor.resolveWith((states) => buttonColor),
        ),
      ),
    );
  }
}
