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

// TODO rename these
const Color top = Color(0xfff07f7e);
const Color br = Color(0xffffd8d6);
const Color bl = Color(0xff543e3d);

Color getTweenBLtoTColor(double t) =>
    Color.lerp(getColor(Side.bl), getColor(Side.t), t)!;

Color getButtonColor(double t) => Color.lerp(backgroundColor, buttonColor, t)!;

// Color get buttonColor => getTweenBLtoTColor(0.7);
// Color get backgroundColor => getTweenBLtoTColor(0.4);
// Color get radioButtonOnColor => getButtonColor(0.3);
// Color get radioButtonOffColor => Color.lerp(getColor(Side.t), getColor(Side.br), 0.3)!;
Color get buttonColor => getTweenBtoGColor(0.7);

Color get backgroundColor => getTweenBtoGColor(0.5);

Color get radioButtonOnColor => getTweenBtoGColor(0.3);

Color get radioButtonOffColor => getButtonColor(0.3);

// from diamond pic
const green = Color(0xFF284CA1);
const blue = Color(0xFF32B875);
// from https://blog.hunterlab.com/blog/color-measurement/understanding-color-harmony-can-help-enhance-consumer-perception-and-experience/
// const green = Color(0xFF5EA79C);
// const blue = Color(0xFF3396AD);

Color getTweenBtoGColor(double t) => Color.lerp(blue, green, t)!;
