import 'package:cube_painter/buttons/hexagon_border.dart';
import 'package:cube_painter/colors.dart';
import 'package:flutter/material.dart';

class HexagonButton extends StatelessWidget {
  final void Function() onPressed;

  final Widget child;

  final double height;

  bool get on => radioOn ?? false;
  final bool? radioOn;
  final String tip;

  const HexagonButton({
    Key? key,
    required this.child,
    required this.onPressed,
    this.height = 100,
    this.radioOn,
    required this.tip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderSide = BorderSide(width: 1.0, color: buttonBorderColor);
    const double elevation = 8.0;

    return Transform.translate(
      offset: Offset(0, on ? 1.0 : -1.0) * elevation / 4,
      // offset: Offset.zero,
      child: ElevatedButton(
        onPressed: onPressed,
        child: child,

        //TODO onLongPressed, tip
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(on ? 0.0 : elevation),
          shadowColor: on ? null : MaterialStateProperty.all(bl),
          padding: MaterialStateProperty.all(const EdgeInsets.all(0.0)),
          // fixedSize: MaterialStateProperty.all(Size(height, height)),
          backgroundColor:
              MaterialStateProperty.resolveWith(getBackgroundColor),
          // side: MaterialStateProperty.all(borderSide),
          shape: MaterialStateProperty.all(HexagonBorder(side: borderSide)),
        ),
      ),
    );
  }

  Color getBackgroundColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      // return radioButtonOnColor;
      // return Color.lerp(top, br, 0.5)!;
      return buttonColor;
    }
    return buttonColor;
    // return top;
  }
}
