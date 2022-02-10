import 'package:cube_painter/buttons/calc_hexagon_points.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/transform/grid_transform.dart';
import 'package:flutter_test/flutter_test.dart';

import 'equals5.dart';

const noWarn = out;

void main() {
  const unitOffset = Offset(1, 1);

  const double x = root3over2;
  const double y = 0.5;

  group('Testing calcHexagonPoints()', () {
    test('point 0', () {
      final List<Offset> points = calcHexagonPoints();
      expect(equals5(points[0], const Offset(x, -y) + unitOffset), true);
    });
    test('point 1', () {
      final List<Offset> points = calcHexagonPoints();
      expect(equals5(points[1], const Offset(0.0, -1.0) + unitOffset), true);
    });
    test('point 2', () {
      final List<Offset> points = calcHexagonPoints();
      expect(equals5(points[2], const Offset(-x, -y) + unitOffset), true);
    });
    test('point 3', () {
      final List<Offset> points = calcHexagonPoints();
      expect(equals5(points[3], const Offset(-x, y) + unitOffset), true);
    });
    test('point 4', () {
      final List<Offset> points = calcHexagonPoints();
      expect(equals5(points[4], const Offset(0.0, 1.0) + unitOffset), true);
    });
    test('point 5', () {
      final List<Offset> points = calcHexagonPoints();
      expect(equals5(points[5], const Offset(x, y) + unitOffset), true);
    });
  });
}
