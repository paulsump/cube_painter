import 'package:cube_painter/out.dart';
import 'package:cube_painter/transform/position_to_unit.dart';
import 'package:cube_painter/transform/screen.dart';
import 'package:flutter/cupertino.dart';

const noWarn = out;

class ScreenMaths {
  late double height;

  double get radius => height / 2;

  double get x => 2 * radius * W;

  double get y => 2 * radius * H;

  double get gap => radius * 0.3;

  late bool orient;
  late Offset offset;

  static const heightFraction = 0.17;
  static const heightFractionOrient = 0.19;

  ScreenMaths({required ScreenNotifier screen})
      : orient = screen.height < screen.width {
    if (orient) {
      height = screen.width * heightFractionOrient / screen.aspect;
      offset = Offset(0, 0);
    } else {
      height = screen.height * heightFraction * screen.aspect;
      offset = Offset(0, screen.height - height);
    }
  }
}
