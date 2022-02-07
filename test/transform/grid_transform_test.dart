import 'package:cube_painter/model/grid_point.dart';
import 'package:cube_painter/transform/grid_transform.dart';
import 'package:flutter_test/flutter_test.dart';

import '../equals5.dart';

void main() {
  group('Testing toOffset()', () {
    test('origin', () {
      const point = GridPoint(0, 0);
      final Offset offset = gridToUnit(point);
      expect(equals5(offset, const Offset(0.0, 0.0)), true);
    });

    test('1,0point x', () {
      const point = GridPoint(1, 0);
      final Offset offset = gridToUnit(point);
      expect(equals5(offset.dx, root3over2), true);
    });
    test('1,0point y', () {
      const point = GridPoint(1, 0);
      final Offset offset = gridToUnit(point);
      expect(equals5(offset.dy, 0.5), true);
    });

    test('0,1point x', () {
      const point = GridPoint(0, 1);
      final Offset offset = gridToUnit(point);
      expect(equals5(offset.dx, 0.0), true);
    });
    test('0,1point y', () {
      const point = GridPoint(0, 1);
      final Offset offset = gridToUnit(point);
      expect(equals5(offset.dy, -1.0), true);
    });

    test('0,2point x', () {
      const point = GridPoint(0, 2);
      final Offset offset = gridToUnit(point);
      expect(equals5(offset.dx, 0.0), true);
    });
    test('0,2point y', () {
      const point = GridPoint(0, 2);
      final Offset offset = gridToUnit(point);
      expect(equals5(offset.dy, -2.0), true);
    });

    test('1,1point x', () {
      const point = GridPoint(1, 1);
      final Offset offset = gridToUnit(point);
      expect(equals5(offset.dx, root3over2), true);
    });
    test('1,1point y', () {
      const point = GridPoint(1, 1);
      final Offset offset = gridToUnit(point);
      expect(equals5(offset.dy, -0.5), true);
    });
  });
}
