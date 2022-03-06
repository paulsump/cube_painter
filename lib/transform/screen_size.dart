import 'dart:math';

import 'package:cube_painter/out.dart';
import 'package:cube_painter/transform/position_to_unit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const noWarn = out;

/// convenient access to screen dimensions.
Size getScreenSize(BuildContext context) => MediaQuery.of(context).size;

double getScreenWidth(BuildContext context) => getScreenSize(context).width;

double getScreenHeight(BuildContext context) => getScreenSize(context).height;

Offset getScreenCenter(BuildContext context) {
  final size = getScreenSize(context);
  return Offset(size.width, size.height) / 2;
}

/// object dimensions calculated using the shortestEdge of the screen...

double screenAdjust(double length, BuildContext context) =>
    length * _getScreenShortestEdge(context);

double _getScreenShortestEdge(BuildContext context) {
  final screen = getScreenSize(context);

  return min(screen.width, screen.height);
}

double _screenAdjustButtonHeight(BuildContext context) =>
    screenAdjust(0.1921, context);

double screenAdjustButtonWidth(BuildContext context) =>
    root3over2 * _screenAdjustButtonHeight(context);

Size screenAdjustButtonSize(BuildContext context) {
  final double buttonHeight = _screenAdjustButtonHeight(context);

  return Size(buttonHeight, buttonHeight);
}

double screenAdjustButtonChildScale(BuildContext context) =>
    0.26 * _screenAdjustButtonHeight(context);

double screenAdjustNormalIconSize(BuildContext context) =>
    0.4 * _screenAdjustButtonHeight(context);

double screenAdjustAssetIconSize(BuildContext context) =>
    0.3 * _screenAdjustButtonHeight(context);

double screenAdjustButtonElevation(BuildContext context) =>
    0.11429 * _screenAdjustButtonHeight(context);

// double screenAdjustTooltipOffsetY(BuildContext context) =>
//     0.78571 * _screenAdjustButtonHeight(context);

double screenAdjustAddIconSize(BuildContext context) =>
    screenAdjust(0.04762, context);

double screenAdjustEraseIconSize(BuildContext context) =>
    screenAdjust(0.057, context);
