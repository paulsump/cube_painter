import 'package:cube_painter/buttons/hexagon_border.dart';
import 'package:cube_painter/colors.dart';
import 'package:flutter/material.dart';

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
    final borderSide = BorderSide(width: 1.0, color: buttonBorderColor);

    return Tooltip(
      message: tip,
      child: TextButton(
        onPressed: onPressed,
        child: child,
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            HexagonBorder(side: borderSide),
          ),
          overlayColor: MaterialStateColor.resolveWith((states) => buttonColor),
        ),
      ),
    );
  }
}
