import 'package:cube_painter/colors.dart';
import 'package:flutter/material.dart';
import 'package:cube_painter/buttons/hexagon_border.dart';

class HexagonButton extends StatelessWidget {
  final void Function() onPressed;

  final Widget child;

  final double height;

  const HexagonButton({
    Key? key,
    required this.child,
    required this.onPressed,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // width: 200.0,
      width: 0.66 * height,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        child: child,
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(8.0),
          shadowColor: MaterialStateProperty.resolveWith(getShadowColor),
          backgroundColor: MaterialStateProperty.resolveWith(getColor),
          shape: MaterialStateProperty.all(
            const HexagonBorder(),
            // const HexagonBorder(side: BorderSide(width: 5)),
            // CircleBorder(),
            // BeveledRectangleBorder(
            //   borderRadius: BorderRadius.circular(12),
            //   side: BorderSide(width: 2.0, color: Colors.lightBlue.shade50),
            // ),
          ),
        ),
      ),
    );
  }

  Color getColor(Set<MaterialState> states) {
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

  Color getShadowColor(Set<MaterialState> states) {
    return br;
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.red;
  }
}
