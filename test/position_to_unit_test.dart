import 'package:cube_painter/persisted/position.dart';
import 'package:cube_painter/transform/position_to_unit.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  group('Testing toOffset()', () {
    test('origin', () {
      const position = Position(0, 0);
      final Offset unitOffset = positionToUnitOffset(position);
      expect(unitOffset.dx, equals(0.0));
      expect(unitOffset.dy, equals(0.0));
    });

    test('1,0 position x', () {
      const position = Position(1, 0);
      final Offset unitOffset = positionToUnitOffset(position);
      expect(unitOffset.dx, equals(root3over2));
    });
    test('1,0 position y', () {
      const position = Position(1, 0);
      final Offset unitOffset = positionToUnitOffset(position);
      expect(unitOffset.dy, equals(0.5));
    });

    test('0,1 position x', () {
      const position = Position(0, 1);
      final Offset unitOffset = positionToUnitOffset(position);
      expect(unitOffset.dx, equals(0.0));
    });
    test('0,1 position y', () {
      const position = Position(0, 1);
      final Offset unitOffset = positionToUnitOffset(position);
      expect(unitOffset.dy, equals(-1.0));
    });

    test('0,2 position x', () {
      const position = Position(0, 2);
      final Offset unitOffset = positionToUnitOffset(position);
      expect(unitOffset.dx, equals(0.0));
    });
    test('0,2 position y', () {
      const position = Position(0, 2);
      final Offset unitOffset = positionToUnitOffset(position);
      expect(unitOffset.dy, equals(-2.0));
    });

    test('1,1 position x', () {
      const position = Position(1, 1);
      final Offset unitOffset = positionToUnitOffset(position);
      expect(unitOffset.dx, equals(root3over2));
    });
    test('1,1 position y', () {
      const position = Position(1, 1);
      final Offset unitOffset = positionToUnitOffset(position);
      expect(unitOffset.dy, equals(-0.5));
    });
  });
}
