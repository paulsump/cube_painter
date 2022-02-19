import 'package:cube_painter/buttons/hexagon_border.dart';
import 'package:cube_painter/colors.dart';
import 'package:flutter/material.dart';

class HexagonButton extends StatelessWidget {
  final void Function() onPressed;

  final Widget child;

  final double height;
  final bool radioOn;

  const HexagonButton({
    Key? key,
    required this.child,
    required this.onPressed,
    required this.height,
    this.radioOn = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderSide = BorderSide(width: 1.0, color: buttonBorderColor);
    const double elevation = 8.0;

    return Transform.translate(
      offset: Offset(0, radioOn ? elevation / 2 : 0.0),
      child: SizedBox(
        width: 0.66 * height,
        height: height,
        child: ElevatedButton(
          onPressed: onPressed,
          child: child,
          style: ButtonStyle(
            elevation: MaterialStateProperty.all(radioOn ? 0.0 : elevation),
            shadowColor: radioOn ? null : MaterialStateProperty.all(bl),
            backgroundColor:
                MaterialStateProperty.resolveWith(getBackgroundColor),
            side: MaterialStateProperty.all(borderSide),
            shape: MaterialStateProperty.all(const HexagonBorder()),
          ),
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
      return Color.lerp(top, br, 0.5)!;
    }
    return top;
  }
}
