import 'dart:math';

import 'package:cube_painter/out.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const noWarn = out;

Size getScreenSize(BuildContext context) => MediaQuery.of(context).size;

double getScreenWidth(BuildContext context) => getScreenSize(context).width;

double getScreenHeight(BuildContext context) => getScreenSize(context).height;

Offset getScreenCenter(BuildContext context) {
  final size = getScreenSize(context);
  return Offset(size.width, size.height) / 2;
}

double calcButtonHeight(BuildContext context) {
  return 0.15152 * getShortestEdge(context);
}

Size calcButtonSize(BuildContext context) {
  final double buttonHeight = calcButtonHeight(context);

  return Size(buttonHeight, buttonHeight);
}

double getShortestEdge(BuildContext context) {
  final screen = getScreenSize(context);

  return min(screen.width, screen.height);
}
