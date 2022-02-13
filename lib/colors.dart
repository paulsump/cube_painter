import 'package:cube_painter/cubes/side.dart';
import 'package:flutter/material.dart';

Color getColor(Side side) {
  switch (side) {
    case Side.br:
      return const Color(0xFFFFD8D6); // Light
    case Side.t:
      return const Color(0xFFF07F7E); // Medium
    case Side.bl:
      return const Color(0xFF543E3D); // Dark
  }
}

Color getTweenBLtoTColor(double t) =>
    Color.lerp(getColor(Side.bl), getColor(Side.t), t)!;

// Color get buttonColor => getTweenBLtoTColor(0.7);
// Color get backgroundColor => getTweenBLtoTColor(0.4);
Color get buttonColor => getTweenBtoGColor(0.7);

Color get backgroundColor => getTweenBtoGColor(0.5);

Color getButtonColor(double t) => Color.lerp(backgroundColor, buttonColor, t)!;

Color get radioButtonOnColor =>
    // getButtonColor(0.3);
    getTweenBtoGColor(0.3);

Color get radioButtonOffColor => getButtonColor(0.3);
// Color.lerp(getColor(Side.t), getColor(Side.br), 0.3)!;

const green = Color(0xFF284CA1);
const blue = Color(0xFF32B875);

Color getTweenBtoGColor(double t) => Color.lerp(blue, green, t)!;
