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

Color disabledIconColor = Colors.grey; //getColor(Side.bl);
Color enabledIconColor = getColor(Side.bl);
Color textColor = enabledIconColor;

// TODO rename these
const Color top = Color(0xfff07f7e);
const Color br = Color(0xffffd8d6);
const Color bl = Color(0xff543e3d);
// const Color top = peachAmber;
// const Color br = softPink;
// const Color bl = arborGreen;

Color getTweenBLtoTColor(double t) =>
    Color.lerp(getColor(Side.bl), getColor(Side.t), t)!;

Color getButtonColor(double t) => Color.lerp(backgroundColor, buttonColor, t)!;

Color get buttonColor => getTweenBtoGColor(0.3);

Color get buttonBorderColor => getTweenBtoGColor(0.9);

Color get backgroundColor => getTweenBtoGColor(0.6);

Color get radioButtonOnColor => getTweenBtoGColor(0.4);

//TODO use or delete
// Color get radioButtonOffColor => getTweenBtoGColor(0.8);

// from https://www.designwizard.com/blog/design-trends/colour-combination
const softPink = Color(0xFFFFDDE2);
const peachAmber = Color(0xFFFAA094);
const yucca = Color(0xFF9ED9CC);
const arborGreen = Color(0xFF008C76);

const green = arborGreen;
const blue = yucca;
// from diamond pic
// const green = Color(0xFF284CA1);
// const blue = Color(0xFF32B875);

Color getTweenBtoGColor(double t) => Color.lerp(blue, green, t)!;
