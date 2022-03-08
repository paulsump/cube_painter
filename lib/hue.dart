import 'package:flutter/material.dart';

class Hue {
  static const Color topColor = Color(0xfff07f7e);
  static const Color bottomRightColor = Color(0xffffd8d6);

  static const Color bottomLeftColor = Color(0xff543e3d);
  static const Color wholeCubeTopTopColor = Color(0xffb16564);

  static final Color topGradientColor = _getTweenBLtoTColor(0.6);
  static final Color disabledIconColor = _getTweenBLtoBRColor(0.5);

  static const _t = 0.4;
  static final Color wireTopColor = _getTweenBLtoTColor(_t);

  static final Color wireBottomRightColor = _getTweenBLtoBRColor(_t);
  static const Color wireBottomLeftColor = bottomLeftColor;

  static const Color enabledIconColor = bottomRightColor;
  static const Color textColor = enabledIconColor;

  static final Color backgroundColor = _getTweenTtoBRColor(0.6);
  static final Color buttonColor = _getTweenTtoBRColor(0.4);

  static final Color buttonBorderColor = _getTweenTtoBRColor(0.1);
  static final Color radioButtonOnColor = _getTweenTtoBRColor(0.3);

  static final Color radioButtonOffColor = buttonColor;
  static final Color _blt = _getTweenBLtoTColor(0.3);

  static final Color alertColor = _blt.withOpacity(0.9);
  static final Color tipColor = _blt;

  static final Color helpColor = _darkBLT.withOpacity(0.8);
  static final Color _darkBLT = _getTweenBLtoTColor(0.1);

  static final Color menuColor = _darkBLT.withOpacity(0.4);
  static final Color scrimColor = _darkBLT.withOpacity(0.5);

  static final Color paintingsMenuButtonsColor = _blt.withOpacity(0.99);
  static final Color horizonColor = _getTweenBLtoTColor(0.4);
}

Color _getTweenBLtoBRColor(double t) =>
    Color.lerp(Hue.bottomLeftColor, Hue.bottomRightColor, t)!;

Color _getTweenBLtoTColor(double t) =>
    Color.lerp(Hue.bottomLeftColor, Hue.topColor, t)!;

Color _getTweenTtoBRColor(double t) =>
    Color.lerp(Hue.topColor, Hue.bottomRightColor, t)!;
