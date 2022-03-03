import 'package:flutter/material.dart';

const Color topColor = Color(0xfff07f7e);
const Color bottomRightColor = Color(0xffffd8d6);
const Color bottomLeftColor = Color(0xff543e3d);

final Color disabledIconColor = _getTweenBLtoBRColor(0.5);

Color _getTweenBLtoBRColor(double t) =>
    Color.lerp(bottomLeftColor, bottomRightColor, t)!;

const Color enabledIconColor = bottomRightColor;
const Color textColor = enabledIconColor;

// TODO change all these from getters to finals
Color getTweenBLtoTColor(double t) => Color.lerp(bottomLeftColor, topColor, t)!;

Color getButtonColor(double t) => Color.lerp(backgroundColor, buttonColor, t)!;

Color get buttonColor => _getTweenTtoBRColor(0.4);

Color get buttonBorderColor => _getTweenTtoBRColor(0.1);

Color get backgroundColor => _getTweenTtoBRColor(0.6);

Color get radioButtonOnColor => _getTweenTtoBRColor(0.4);

final Color _blt = getTweenBLtoTColor(0.3);

Color get paintingsMenuButtonsColor => _blt.withOpacity(0.7);

Color get alertColor => _blt.withOpacity(0.9);

Color _getTweenTtoBRColor(double t) =>
    Color.lerp(topColor, bottomRightColor, t)!;
