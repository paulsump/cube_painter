import 'package:cube_painter/out.dart';
import 'package:cube_painter/transform/position_to_unit.dart';
import 'package:cube_painter/transform/screen.dart';

const noWarn = out;

class ScreenMaths {
  final ScreenNotifier screen;
  final double height;

  final double offsetY;

  double get radius => height / 2;

  double get x => 2 * radius * W;

  double get y => 2 * radius * H;

  double get gap => radius * 0.3;

  late bool orient;

  ScreenMaths({
    required this.screen,
    required this.height,
    required this.offsetY,
  }) {
    orient = screen.height < screen.width;
  }
}
