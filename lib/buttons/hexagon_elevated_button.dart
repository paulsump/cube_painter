import 'package:cube_painter/buttons/hexagon_border.dart';
import 'package:cube_painter/colors.dart';
import 'package:cube_painter/constants.dart';
import 'package:flutter/material.dart';

class HexagonElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed;

  final Widget child;


  bool get on => radioOn ?? false;
  final bool? radioOn;
  final String tip;

  const HexagonElevatedButton({
    Key? key,
    required this.child,
    required this.onPressed,
    required this.tip,
    this.radioOn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Transform.translate(
      offset: Offset(0, on ? 1.0 : -1.0) * buttonElevation / 4,
      child: Tooltip(
        message: tip,
        decoration: BoxDecoration(color: backgroundColor.withOpacity(0.7)),
        child: _buildElevatedButton(),
      ),
    );
  }

  ElevatedButton _buildElevatedButton() {

    return ElevatedButton(
      onPressed: onPressed,
      child: child,
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(on ? 0.0 : buttonElevation),
        shadowColor: on ? null : MaterialStateProperty.all(bl),
        fixedSize: MaterialStateProperty.all(pageButtonSize),
        shape: hexagonBorderShape,
        backgroundColor: MaterialStateProperty.all(radioOn == null
            ? buttonColor
            : radioOn!
                ? radioButtonOnColor
                : buttonColor),
      ),
    );
  }
}
