import 'package:cube_painter/shared/enums.dart';
import 'package:flutter/material.dart';

Color getColor(Vert vert){
  switch(vert){
    case Vert.br: return const Color(0xFFFFD8D6); // Light
    case Vert.t: return  const Color(0xFFF07F7E); // Medium
    case Vert.bl: return const Color(0xFF543E3D); // Dark
  }
}
