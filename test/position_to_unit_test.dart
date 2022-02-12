import 'package:cube_painter/data/position.dart';
import 'package:cube_painter/transform/position_to_unit.dart';
import 'package:flutter_test/flutter_test.dart';

import 'equals5.dart';

void main() {
  group('Testing toOffset()', () {
    test('origin', () {
      const position = Position(0, 0);
      final Offset unitOffset = positionToUnitOffset(position);
      expect(equals5(unitOffset, const Offset(0.0, 0.0)), true);
    });

    test('1,0 position x', () {
      const position = Position(1, 0);
      final Offset unitOffset = positionToUnitOffset(position);
      expect(equals5(unitOffset.dx, root3over2), true);
    });
    test('1,0 position y', () {
      const position = Position(1, 0);
      final Offset unitOffset = positionToUnitOffset(position);
      expect(equals5(unitOffset.dy, 0.5), true);
    });

    test('0,1 position x', () {
      const position = Position(0, 1);
      final Offset unitOffset = positionToUnitOffset(position);
      expect(equals5(unitOffset.dx, 0.0), true);
    });
    test('0,1 position y', () {
      const position = Position(0, 1);
      final Offset unitOffset = positionToUnitOffset(position);
      expect(equals5(unitOffset.dy, -1.0), true);
    });

    test('0,2 position x', () {
      const position = Position(0, 2);
      final Offset unitOffset = positionToUnitOffset(position);
      expect(equals5(unitOffset.dx, 0.0), true);
    });
    test('0,2 position y', () {
      const position = Position(0, 2);
      final Offset unitOffset = positionToUnitOffset(position);
      expect(equals5(unitOffset.dy, -2.0), true);
    });

    test('1,1 position x', () {
      const position = Position(1, 1);
      final Offset unitOffset = positionToUnitOffset(position);
      expect(equals5(unitOffset.dx, root3over2), true);
    });
    test('1,1 position y', () {
      const position = Position(1, 1);
      final Offset unitOffset = positionToUnitOffset(position);
      expect(equals5(unitOffset.dy, -0.5), true);
    });
  });
}
