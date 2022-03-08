import 'package:cube_painter/buttons/hexagon_border.dart';
import 'package:cube_painter/hue.dart';
import 'package:cube_painter/transform/screen_size.dart';
import 'package:flutter/material.dart';

/// A hexagon shaped [ElevatedButton] (with a drop shadow).
///
/// The underlying class for radio and push buttons.
/// Raised with a shadow, as opposed to the flat [HexagonBorderButton].
class ElevatedHexagonButton extends StatelessWidget {
  const ElevatedHexagonButton({
    Key? key,
    required this.child,
    required this.onPressed,
    required this.tip,
    this.isRadioOn,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final Widget child;

  bool get isOn => isRadioOn ?? false;
  final bool? isRadioOn;

  final String tip;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screenAdjustButtonWidth(context),
      child: Transform.translate(
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
                  ? Hue.buttonColor
                  : isRadioOn!
                      ? Hue.radioButtonOnColor
                      : Hue.radioButtonOffColor),
              elevation: MaterialStateProperty.all(
                  isOn ? 0.0 : screenAdjustButtonElevation(context)),
              shadowColor:
                  isOn ? null : MaterialStateProperty.all(Hue.bottomLeftColor),
            ),
          ),
        ),
      ),
    );
  }
}
