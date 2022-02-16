import 'package:cube_painter/out.dart';
import 'package:cube_painter/transform/position_to_unit.dart';
import 'package:cube_painter/transform/screen.dart';
import 'package:flutter/cupertino.dart';

const noWarn = out;

class ScreenMaths {
  late double radius;

  late double width;
  late double height;

  double get x => 2 * radius * W;

  double get y => 2 * radius * H;

  double get gap => radius * 0.3;

  late bool orient;
  late Offset offset;

  static const radiusFactor = 0.085;
  static const radiusFactorOrient = 0.093;

  ScreenMaths({required ScreenNotifier screen})
      : orient = screen.height < screen.width {
    if (orient) {
      radius = screen.width * radiusFactorOrient / screen.aspect;
      //todo set x for ios
      offset = Offset(-screen.safeArea.width, 0);
      //TODO FIX
      width = screen.width / 8;
      height = screen.height;
    } else {
      const double padY = 11;
      radius = screen.height * radiusFactor * screen.aspect;
      offset = Offset(0, screen.height - 2 * radius - 2 * padY);
      width = screen.width;
      //todo reduce
      height = screen.width;
    }
  }
}
