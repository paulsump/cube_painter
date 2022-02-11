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

Color tweenDarkColor(double t) =>
    Color.lerp(getColor(Side.t), getColor(Side.bl), t)!;

Color get buttonColor => tweenDarkColor(0.3);

Color get backgroundColor => tweenDarkColor(0.6);
