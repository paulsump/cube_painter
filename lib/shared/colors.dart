import 'package:cube_painter/shared/enums.dart';
import 'package:flutter/material.dart';

Color getColor(Vert vert){
  switch(vert){
    case Vert.br: return const Color(0xFFFFD8D6); // Light
    case Vert.t: return  const Color(0xFFF07F7E); // Medium
    case Vert.bl: return const Color(0xFF543E3D); // Dark
  }
}

Animatable<Color?> colorSequence = TweenSequence<Color?>(
  [
    TweenSequenceItem(
      weight: 10.0,
      tween: ColorTween(
        begin: getColor(Vert.bl),
        end: getColor(Vert.t),
      ),
    ),
    TweenSequenceItem(
      weight: 5.0,
      tween: ColorTween(
        begin: getColor(Vert.t),
        end: getColor(Vert.br),
      ),
    ),
    TweenSequenceItem(
      weight: 4.0,
      tween: ColorTween(
        begin: getColor(Vert.br),
        end: getColor(Vert.t),
      ),
    ),
    TweenSequenceItem(
      weight: 10.0,
      tween: ColorTween(
        begin: getColor(Vert.t),
        end: getColor(Vert.bl),
      ),
    ),
  ],
);
