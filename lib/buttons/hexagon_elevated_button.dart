import 'package:cube_painter/buttons/hexagon_border.dart';
import 'package:cube_painter/colors.dart';
import 'package:cube_painter/constants.dart';
import 'package:flutter/material.dart';

/// A hexagon shaped button with a drop shadow.
class HexagonElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed;

  final Widget child;

  bool get isOn => isRadioOn ?? false;
  final bool? isRadioOn;
  final String tip;

  /// The underlying class for radio and push buttons.
  /// Raised with a shadow, as opposed to the flat [HexagonBorderButton].
  const HexagonElevatedButton({
    Key? key,
    required this.child,
    required this.onPressed,
    required this.tip,
    this.isRadioOn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, isOn ? 1.0 : -1.0) * buttonElevation / 4,
      child: Tooltip(
        message: tip,
        decoration: BoxDecoration(color: backgroundColor.withOpacity(0.7)),
        child: ElevatedButton(
          onPressed: onPressed,
          child: child,
          style: ButtonStyle(
            shape: hexagonBorderShape,
            fixedSize: MaterialStateProperty.all(pageButtonSize),
            backgroundColor: MaterialStateProperty.all(isRadioOn == null
                ? buttonColor
                : isRadioOn!
                    ? radioButtonOnColor
                    : buttonColor),
            elevation: MaterialStateProperty.all(isOn ? 0.0 : buttonElevation),
            shadowColor: isOn ? null : MaterialStateProperty.all(bl),
          ),
        ),
      ),
    );
  }
}
