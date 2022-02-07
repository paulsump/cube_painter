import 'package:cube_painter/rendering/side.dart';
import 'package:flutter/material.dart';

Color getColor(Side vert) {
  switch (vert) {
    case Side.br:
      return const Color(0xFFFFD8D6); // Light
    case Side.t:
      return const Color(0xFFF07F7E); // Medium
    case Side.bl:
      return const Color(0xFF543E3D); // Dark
  }
}
