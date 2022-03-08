import 'package:flutter/material.dart';

/// Access to all the colors in the app
class Hue {
  static const Color top = Color(0xfff07f7e);
  static const Color bottomRight = Color(0xffffd8d6);

  static const Color bottomLeft = Color(0xff543e3d);
  static const Color wholeCubeTopTop = Color(0xffb16564);

  static final Color topGradient = _getTweenBLtoTColor(0.6);
  static final Color disabledIcon = _getTweenBLtoBRColor(0.5);

  static const _t = 0.4;
  static final Color wireTop = _getTweenBLtoTColor(_t);

  static final Color wireBottomRight = _getTweenBLtoBRColor(_t);
  static const Color wireBottomLeft = bottomLeft;

  static const Color enabledIcon = bottomRight;
  static const Color text = enabledIcon;

  static final Color background = _getTweenTtoBRColor(0.6);
  static final Color button = _getTweenTtoBRColor(0.4);

  static final Color buttonBorder = _getTweenTtoBRColor(0.1);
  static final Color radioButtonOn = _getTweenTtoBRColor(0.3);

  static final Color radioButtonOff = button;
  static final Color _blt = _getTweenBLtoTColor(0.3);

  static final Color alert = _blt.withOpacity(0.9);
  static final Color tip = _blt;

  static final Color help = _darkBLT.withOpacity(0.8);
  static final Color _darkBLT = _getTweenBLtoTColor(0.1);

  static final Color menu = _darkBLT.withOpacity(0.4);
  static final Color scrim = _darkBLT.withOpacity(0.5);

  static final Color paintingsMenuButtons = _blt.withOpacity(0.99);
  static final Color horizon = _getTweenBLtoTColor(0.4);
}

Color _getTweenBLtoBRColor(double t) =>
    Color.lerp(Hue.bottomLeft, Hue.bottomRight, t)!;

Color _getTweenBLtoTColor(double t) => Color.lerp(Hue.bottomLeft, Hue.top, t)!;

Color _getTweenTtoBRColor(double t) => Color.lerp(Hue.top, Hue.bottomRight, t)!;
