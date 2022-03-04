import 'package:flutter/material.dart';

const Color topColor = Color(0xfff07f7e);
const Color bottomRightColor = Color(0xffffd8d6);
const Color bottomLeftColor = Color(0xff543e3d);

const Color wholeCubeTopTopColor = Color(0xffb16564);
final Color disabledIconColor = _getTweenBLtoBRColor(0.5);

Color _getTweenBLtoBRColor(double t) =>
    Color.lerp(bottomLeftColor, bottomRightColor, t)!;

Color _getTweenBLtoTColor(double t) =>
    Color.lerp(bottomLeftColor, topColor, t)!;

const _t = 0.4;

/// TODO CHANGE TO FINAL
Color get wireBottomRightColor => _getTweenBLtoBRColor(_t);

Color get wireBottomLeftColor => bottomLeftColor;

Color get wireTopColor => _getTweenBLtoTColor(_t);

const Color enabledIconColor = bottomRightColor;
const Color textColor = enabledIconColor;

Color getTweenBLtoTColor(double t) => Color.lerp(bottomLeftColor, topColor, t)!;

Color getButtonColor(double t) => Color.lerp(backgroundColor, buttonColor, t)!;

final Color buttonColor = _getTweenTtoBRColor(0.4);

final Color buttonBorderColor = _getTweenTtoBRColor(0.1);

final Color backgroundColor = _getTweenTtoBRColor(0.6);

final Color radioButtonOnColor = _getTweenTtoBRColor(0.4);

final Color _blt = getTweenBLtoTColor(0.3);

final Color paintingsMenuButtonsColor = _blt.withOpacity(0.7);

final Color alertColor = _blt.withOpacity(0.9);

final Color tipColor = _blt;

Color _getTweenTtoBRColor(double t) =>
    Color.lerp(topColor, bottomRightColor, t)!;

Color horizonColor = getTweenBLtoTColor(0.4);
