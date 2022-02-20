import 'package:cube_painter/buttons/hexagon_border.dart';
import 'package:cube_painter/colors.dart';
import 'package:cube_painter/out.dart';
import 'package:flutter/material.dart';

class HexagonButton extends StatelessWidget {
  final VoidCallback? onPressed;

  final Widget child;

  final double height;

  bool get on => radioOn ?? false;
  final bool? radioOn;
  final String tip;

  const HexagonButton({
    Key? key,
    required this.child,
    required this.onPressed,
    this.height = 70,
    this.radioOn,
    required this.tip,
//TODO ENABLED FOr redo
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderSide = BorderSide(width: 1.0, color: buttonBorderColor);
    const double elevation = 8.0;

    return Transform.translate(
      offset: Offset(0, on ? 1.0 : -1.0) * elevation / 4,
      child: ElevatedButton(
        onPressed: onPressed,
        onLongPress: () {
          //TODO tip
          out(tip);
        },
        child: child,
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(on ? 0.0 : elevation),
          shadowColor: on ? null : MaterialStateProperty.all(bl),
          minimumSize: MaterialStateProperty.all(Size(height, height)),
          shape: MaterialStateProperty.all(
            HexagonBorder(side: borderSide),
          ),
          backgroundColor: MaterialStateProperty.all(radioOn == null
              ? buttonColor
              : radioOn!
                  ? radioButtonOnColor
                  : buttonColor),
        ),
      ),
    );
  }
}
