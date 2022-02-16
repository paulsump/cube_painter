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

  static const heightFraction = 0.17;
  static const heightFractionOrient = 0.19;

  ScreenMaths({required ScreenNotifier screen})
      : offsetY = screen.height,
        orient = screen.height < screen.width,
        height = screen.height < screen.width
            ? screen.width * heightFractionOrient / screen.aspect
            : screen.height * heightFraction * screen.aspect;
}
