import 'package:cube_painter/cubes/cube_sides.dart';
import 'package:flutter/material.dart';

Color getColor(Side side) {
  switch (side) {
    case Side.br:
      return const Color(0xffffd8d6); // Light
    case Side.t:
      return const Color(0xfff07f7e); // Medium
    case Side.bl:
      return const Color(0xff543e3d); // Dark
  }
}

final Color disabledIconColor = _getTweenBLtoBRColor(0.5);

Color _getTweenBLtoBRColor(double t) =>
    Color.lerp(getColor(Side.bl), getColor(Side.br), t)!;

final Color enabledIconColor = getColor(Side.br);
final Color textColor = enabledIconColor;

// TODO rename these
const Color top = Color(0xfff07f7e);
const Color br = Color(0xffffd8d6);
const Color bl = Color(0xff543e3d);

// TODO change all these from getters to finals
Color getTweenBLtoTColor(double t) =>
    Color.lerp(getColor(Side.bl), getColor(Side.t), t)!;

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

final green = getColor(Side.br);
final blue = getColor(Side.t);

Color getTweenBtoGColor(double t) => Color.lerp(blue, green, t)!;
