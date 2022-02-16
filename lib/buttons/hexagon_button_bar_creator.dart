import 'dart:math';

import 'package:cube_painter/out.dart';
import 'package:cube_painter/transform/position_to_unit.dart';
import 'package:cube_painter/transform/screen.dart';

const noWarn = out;

class ScreenMaths {
  double height;

  double offsetY;

  double get radius => height / 2;

  double get x => 2 * radius * W;

  double get y => 2 * radius * H;

  double get gap => radius * 0.3;

  late bool orient;

  ScreenMaths({required ScreenNotifier screen})
      : height = max(screen.width, screen.height) / 12,
        offsetY = screen.height,
        orient = screen.height < screen.width;
}
