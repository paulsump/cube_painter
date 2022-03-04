import 'package:cube_painter/buttons/hexagon_border.dart';
import 'package:cube_painter/colors.dart';
import 'package:cube_painter/transform/screen_size.dart';
import 'package:flutter/material.dart';

/// A hexagon shaped button with a drop shadow.
class ElevatedHexagonButton extends StatelessWidget {
  final VoidCallback? onPressed;

  final Widget child;

  bool get isOn => isRadioOn ?? false;
  final bool? isRadioOn;
  final String tip;

  /// The underlying class for radio and push buttons.
  /// Raised with a shadow, as opposed to the flat [HexagonBorderButton].
  const ElevatedHexagonButton({
    Key? key,
    required this.child,
    required this.onPressed,
    required this.tip,
    this.isRadioOn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, isOn ? 1.0 : -1.0) *
          screenAdjustButtonElevation(context) /
          4,
      child: Tooltip(
        message: tip,
        child: ElevatedButton(
          onPressed: onPressed,
          child: child,
          style: ButtonStyle(
            shape: hexagonBorderShape,
            fixedSize:
                MaterialStateProperty.all(screenAdjustButtonSize(context)),
            backgroundColor: MaterialStateProperty.all(isRadioOn == null
                ? buttonColor
                : isRadioOn!
                    ? radioButtonOnColor
                    : radioButtonOffColor),
            elevation: MaterialStateProperty.all(
                isOn ? 0.0 : screenAdjustButtonElevation(context)),
            shadowColor:
                isOn ? null : MaterialStateProperty.all(bottomLeftColor),
          ),
        ),
      ),
    );
  }
}
