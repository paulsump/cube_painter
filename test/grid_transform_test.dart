import 'package:cube_painter/data/position.dart';
import 'package:cube_painter/transform/grid_transform.dart';
import 'package:flutter_test/flutter_test.dart';

import 'equals5.dart';

void main() {
  group('Testing toOffset()', () {
    test('origin', () {
      const position = Position(0, 0);
      final Offset offset = positionToUnitOffset(position);
      expect(equals5(offset, const Offset(0.0, 0.0)), true);
    });

    test('1,0 position x', () {
      const position = Position(1, 0);
      final Offset offset = positionToUnitOffset(position);
      expect(equals5(offset.dx, root3over2), true);
    });
    test('1,0 position y', () {
      const position = Position(1, 0);
      final Offset offset = positionToUnitOffset(position);
      expect(equals5(offset.dy, 0.5), true);
    });

    test('0,1 position x', () {
      const position = Position(0, 1);
      final Offset offset = positionToUnitOffset(position);
      expect(equals5(offset.dx, 0.0), true);
    });
    test('0,1 position y', () {
      const position = Position(0, 1);
      final Offset offset = positionToUnitOffset(position);
      expect(equals5(offset.dy, -1.0), true);
    });

    test('0,2 position x', () {
      const position = Position(0, 2);
      final Offset offset = positionToUnitOffset(position);
      expect(equals5(offset.dx, 0.0), true);
    });
    test('0,2 position y', () {
      const position = Position(0, 2);
      final Offset offset = positionToUnitOffset(position);
      expect(equals5(offset.dy, -2.0), true);
    });

    test('1,1 position x', () {
      const position = Position(1, 1);
      final Offset offset = positionToUnitOffset(position);
      expect(equals5(offset.dx, root3over2), true);
    });
    test('1,1 position y', () {
      const position = Position(1, 1);
      final Offset offset = positionToUnitOffset(position);
      expect(equals5(offset.dy, -0.5), true);
    });
  });
}
