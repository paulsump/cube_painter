import 'package:cube_painter/buttons/calc_hexagon_points.dart';
import 'package:cube_painter/buttons/hexagon.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/transform/grid_transform.dart';
import 'package:flutter_test/flutter_test.dart';


const noWarn = out;

void main() {

  const double x = root3over2;
  const double y = 0.5;

  const double delta = 0.00001;

  group('Testing calcHexagonPoints()', () {
    test('point 0', () {
      final List<Offset> points = calcHexagonPoints();
      final offset = const Offset(x, -y) + unitOffset;
      expect(points[0].dx, closeTo(offset.dx, delta));
      expect(points[0].dy, closeTo(offset.dy, delta));
    });
    test('point 1', () {
      final List<Offset> points = calcHexagonPoints();
      final offset = const Offset(0.0, -1.0) + unitOffset;
      expect(points[1].dx, closeTo(offset.dx, delta));
      expect(points[1].dy, closeTo(offset.dy, delta));
    });
    test('point 2', () {
      final List<Offset> points = calcHexagonPoints();
      final offset = const Offset(-x, -y) + unitOffset;
      expect(points[2].dx, closeTo(offset.dx, delta));
      expect(points[2].dy, closeTo(offset.dy, delta));
    });
    test('point 3', () {
      final List<Offset> points = calcHexagonPoints();
      final offset = const Offset(-x, y) + unitOffset;
      expect(points[3].dx, closeTo(offset.dx, delta));
      expect(points[3].dy, closeTo(offset.dy, delta));
    });
    test('point 4', () {
      final List<Offset> points = calcHexagonPoints();
      final offset = const Offset(0.0, 1.0) + unitOffset;
      expect(points[4].dx, closeTo(offset.dx, delta));
      expect(points[4].dy, closeTo(offset.dy, delta));
    });
    test('point 5', () {
      final List<Offset> points = calcHexagonPoints();
      final offset = const Offset(x, y) + unitOffset;
      expect(points[5].dx, closeTo(offset.dx, delta));
      expect(points[5].dy, closeTo(offset.dy, delta));
    });
  });
}
