import 'package:cube_painter/out.dart';
import 'package:cube_painter/transform/position_to_unit.dart';
import 'package:cube_painter/transform/screen.dart';
import 'package:flutter/cupertino.dart';

const noWarn = out;

class ScreenMaths {

  late double radius;

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
      offset = Offset(0, 0);
    } else {
      radius = screen.height * radiusFactor * screen.aspect;
      offset = Offset(0, screen.height - 2 * radius);
    }
  }
}
