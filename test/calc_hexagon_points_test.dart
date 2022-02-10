import 'package:cube_painter/buttons/calc_hexagon_points.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/transform/grid_transform.dart';
import 'package:flutter_test/flutter_test.dart';

import 'equals5.dart';

const noWarn = out;

void main() {
  const double x = root3over2;
  const double y = 0.5;
  const unitOffset = Offset(1, 1);

  group('Testing calcHexagonPoints()', () {
    test('Testing calcUnitHexagonPoints()', () {
      final List<Offset> points = calcUnitHexagonPoints().toList();
      expect(equals5(points[0], const Offset(x, -y) + unitOffset), true);
    });
    test('Testing calcUnitHexagonPoints()', () {
      final List<Offset> points = calcUnitHexagonPoints().toList();
      expect(equals5(points[1], const Offset(0.0, -1.0) + unitOffset), true);
    });
    test('Testing calcUnitHexagonPoints()', () {
      final List<Offset> points = calcUnitHexagonPoints().toList();
      expect(equals5(points[2], const Offset(-x, -y) + unitOffset), true);
    });
    test('Testing calcUnitHexagonPoints()', () {
      final List<Offset> points = calcUnitHexagonPoints().toList();
      expect(equals5(points[3], const Offset(-x, y) + unitOffset), true);
    });
    test('Testing calcUnitHexagonPoints()', () {
      final List<Offset> points = calcUnitHexagonPoints().toList();
      expect(equals5(points[4], const Offset(0.0, 1.0) + unitOffset), true);
    });
    test('Testing calcUnitHexagonPoints()', () {
      final List<Offset> points = calcUnitHexagonPoints().toList();
      expect(equals5(points[5], const Offset(x, y) + unitOffset), true);
    });
    // test('origin', () {
    //   final List<Offset> points = calcHexagonPoints(Offset.zero, 1);
    //   expect(equals5(points[0], const Offset(x, -y)), true);
    // });
    // test('Testing calcUnitHexagonPoints()', () {
    //   final List<Offset> points = calcHexagonPoints(Offset.zero, 1);
    //   expect(equals5(points[1], const Offset(0.0, -1.0)), true);
    // });
    // test('Testing calcUnitHexagonPoints()', () {
    //   final List<Offset> points = calcHexagonPoints(Offset.zero, 1);
    //   expect(equals5(points[2], const Offset(-x, -y)), true);
    // });
    // test('Testing calcUnitHexagonPoints()', () {
    //   final List<Offset> points = calcHexagonPoints(Offset.zero, 1);
    //   expect(equals5(points[3], const Offset(-x, y)), true);
    // });
    // test('Testing calcUnitHexagonPoints()', () {
    //   final List<Offset> points = calcHexagonPoints(Offset.zero, 1);
    //   expect(equals5(points[4], const Offset(0.0, 1.0)), true);
    // });
    // test('Testing calcUnitHexagonPoints()', () {
    //   final List<Offset> points = calcHexagonPoints(Offset.zero, 1);
    //   // out(points);
    //   expect(equals5(points[5], const Offset(x, y)), true);
    // });
    // test('Testing calcUnitHexagonPoints()', () {
    //   final List<Offset> points = calcHexagonPoints(Offset.zero, 10);
    //   expect(equals5(points[0], const Offset(10 * x, -10 * y)), true);
    // });
    // test('Testing calcUnitHexagonPoints()', () {
    //   final List<Offset> points = calcHexagonPoints(const Offset(1, 0), 10);
    //   expect(equals5(points[0], const Offset(10 * x + 1, -10 * y)), true);
    // });
    // test('Testing calcUnitHexagonPoints()', () {
    //   final List<Offset> points = calcHexagonPoints(const Offset(1, 1), 10);
    //   expect(equals5(points[0], const Offset(10 * x + 1, 1 - 10 * y)), true);
    // });
  });
}
