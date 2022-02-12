import 'package:cube_painter/data/position.dart';
import 'package:cube_painter/transform/position_to_unit.dart';
import 'package:flutter_test/flutter_test.dart';

import 'equals_to_five_decimal_places.dart';

void main() {
  group('Testing toOffset()', () {
    test('origin', () {
      const position = Position(0, 0);
      final Offset unitOffset = positionToUnitOffset(position);
      expect(unitOffset.dx, closeTo(0.0, toFiveDecimalPlaces));
      expect(unitOffset.dy, closeTo(0.0, toFiveDecimalPlaces));
    });

    test('1,0 position x', () {
      const position = Position(1, 0);
      final Offset unitOffset = positionToUnitOffset(position);
      expect(unitOffset.dx, closeTo(root3over2, toFiveDecimalPlaces));
    });
    test('1,0 position y', () {
      const position = Position(1, 0);
      final Offset unitOffset = positionToUnitOffset(position);
      expect(unitOffset.dy, closeTo(0.5, toFiveDecimalPlaces));
    });

    test('0,1 position x', () {
      const position = Position(0, 1);
      final Offset unitOffset = positionToUnitOffset(position);
      expect(unitOffset.dx, closeTo(0.0, toFiveDecimalPlaces));
    });
    test('0,1 position y', () {
      const position = Position(0, 1);
      final Offset unitOffset = positionToUnitOffset(position);
      expect(unitOffset.dy, closeTo(-1.0, toFiveDecimalPlaces));
    });

    test('0,2 position x', () {
      const position = Position(0, 2);
      final Offset unitOffset = positionToUnitOffset(position);
      expect(unitOffset.dx, closeTo(0.0, toFiveDecimalPlaces));
    });
    test('0,2 position y', () {
      const position = Position(0, 2);
      final Offset unitOffset = positionToUnitOffset(position);
      expect(unitOffset.dy, closeTo(-2.0, toFiveDecimalPlaces));
    });

    test('1,1 position x', () {
      const position = Position(1, 1);
      final Offset unitOffset = positionToUnitOffset(position);
      expect(unitOffset.dx, closeTo(root3over2, toFiveDecimalPlaces));
    });
    test('1,1 position y', () {
      const position = Position(1, 1);
      final Offset unitOffset = positionToUnitOffset(position);
      expect(unitOffset.dy, closeTo(-0.5, toFiveDecimalPlaces));
    });
  });
}
