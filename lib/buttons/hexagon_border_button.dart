import 'package:cube_painter/buttons/hexagon_border.dart';
import 'package:cube_painter/colors.dart';
import 'package:flutter/material.dart';

/// A flat looking button compared to the raised [HexagonElevatedButton].
/// Used in two ways on the [PaintingsMenu].
class HexagonBorderButton extends StatelessWidget {
  final VoidCallback? onPressed;

  final Widget child;
  final String tip;

  const HexagonBorderButton({
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
