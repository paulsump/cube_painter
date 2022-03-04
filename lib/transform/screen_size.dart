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

// object dimensions calculated using the shortestEdge of the screen...

double screenAdjust(double length, BuildContext context) =>
    length * _getScreenShortestEdge(context);

double _getScreenShortestEdge(BuildContext context) {
  final screen = getScreenSize(context);

  return min(screen.width, screen.height);
}

double _calcButtonHeight(BuildContext context) =>
    screenAdjust(0.15152, context);

Size calcButtonSize(BuildContext context) {
  final double buttonHeight = _calcButtonHeight(context);

  return Size(buttonHeight, buttonHeight);
}

double calcButtonChildScale(BuildContext context) =>
    0.3 * _calcButtonHeight(context);

double calcNormalIconSize(BuildContext context) =>
    0.47143 * _calcButtonHeight(context);

double calcAssetIconSize(BuildContext context) =>
    0.38571 * _calcButtonHeight(context);

double calcButtonElevation(BuildContext context) =>
    0.11429 * _calcButtonHeight(context);

// double calcTooltipOffsetY(BuildContext context) =>
//     0.78571 * _calcButtonHeight(context);
