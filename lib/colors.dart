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

Color _getTweenDarkColor(double t) =>
    Color.lerp(getColor(Side.t), getColor(Side.bl), t)!;

Color get buttonColor => _getTweenDarkColor(0.3);

Color get backgroundColor => _getTweenDarkColor(0.6);

Color getButtonColor(double t) => Color.lerp(backgroundColor, buttonColor, t)!;
