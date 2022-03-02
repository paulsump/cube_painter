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

Color get buttonColor => getTweenBtoGColor(0.4);

Color get buttonBorderColor => getTweenBtoGColor(0.1);

Color get backgroundColor => getTweenBtoGColor(0.6);

Color get radioButtonOnColor => getTweenBtoGColor(0.4);

Color get paintingsMenuButtonsColor => getTweenBLtoTColor(0.3).withOpacity(0.7);

// const softPink = Color(0xFFFFDDE2);
// const peachAmber = Color(0xFFFAA094);
// const yucca = Color(0xFF9ED9CC);
// const arborGreen = Color(0xFF008C76);

// TODO RENAME B G COLORS
const green = bottomRightColor;
const blue = topColor;

// TODO RENAME B G COLORS
Color getTweenBtoGColor(double t) => Color.lerp(blue, green, t)!;
