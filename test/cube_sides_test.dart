import 'package:cube_painter/cubes/cube_sides.dart';
import 'package:cube_painter/cubes/side.dart';
import 'package:cube_painter/data/crop.dart';
import 'package:flutter_test/flutter_test.dart';

import 'equals5.dart';

void main() {
  group('Crop', () {
    test('c', () {
      final sidesAndUnitOffsets = getCubeSidesAndUnitOffsets(Crop.c);

      expect(Side.bl, equals(sidesAndUnitOffsets[0][0]));
      expect(
          equals5(sidesAndUnitOffsets[0][1], const [
            Offset(0, 0.0),
            Offset(0, 1.0),
            Offset(-0.86602, 0.5),
            Offset(-0.86602, -0.5),
          ]),
          true);

      expect(Side.t, equals(sidesAndUnitOffsets[1][0]));
      expect(
          equals5(sidesAndUnitOffsets[1][1], const [
            Offset(0, 0.0),
            Offset(-0.86602, -0.5),
            Offset(0, -1.0),
            Offset(0.86603, -0.5),
          ]),
          true);

      expect(Side.br, equals(sidesAndUnitOffsets[2][0]));
      expect(
          equals5(sidesAndUnitOffsets[2][1], const [
            Offset(0, 0.0),
            Offset(0.86603, -0.5),
            Offset(0.86603, 0.5),
            Offset(0, 1.0),
          ]),
          true);
    });

    test('r', () {
      final sidesAndUnitOffsets = getCubeSidesAndUnitOffsets(Crop.r);

      expect(Side.t, equals(sidesAndUnitOffsets[0][0]));
      expect(
          equals5(sidesAndUnitOffsets[0][1], const [
            Offset(0, 0.0),
            Offset(-0.86602, -0.5),
            Offset(0, -1.0),
          ]),
          true);

      expect(Side.bl, equals(sidesAndUnitOffsets[1][0]));
      expect(
          equals5(sidesAndUnitOffsets[1][1], const [
            Offset(0, 0.0),
            Offset(0, 1.0),
            Offset(-0.86602, 0.5),
            Offset(-0.86602, -0.5),
          ]),
          true);
    });

    test('ur', () {
      final sidesAndUnitOffsets = getCubeSidesAndUnitOffsets(Crop.ur);

      expect(Side.bl, equals(sidesAndUnitOffsets[0][0]));

      expect(
          equals5(sidesAndUnitOffsets[0][1], const [
            Offset(0, 0.0),
            Offset(0, 1.0),
            Offset(-0.86602, 0.5),
            Offset(-0.86602, -0.5),
          ]),
          true);

      expect(Side.br, equals(sidesAndUnitOffsets[1][0]));
      expect(
          equals5(sidesAndUnitOffsets[1][1], const [
            Offset(0, 0.0),
            Offset(0.86603, 0.5),
            Offset(0, 1.0),
          ]),
          true);
    });

    test('ul', () {
      final sidesAndUnitOffsets = getCubeSidesAndUnitOffsets(Crop.ul);

      expect(Side.bl, equals(sidesAndUnitOffsets[0][0]));

      expect(
          equals5(sidesAndUnitOffsets[0][1], const [
            Offset(0, 0.0),
            Offset(0, 1.0),
            Offset(-0.86602, 0.5),
          ]),
          true);

      expect(Side.br, equals(sidesAndUnitOffsets[1][0]));

      expect(
          equals5(sidesAndUnitOffsets[1][1], const [
            Offset(0, 0.0),
            Offset(0.86603, -0.5),
            Offset(0.86603, 0.5),
            Offset(0, 1.0),
          ]),
          true);
    });

    test('l', () {
      final sidesAndUnitOffsets = getCubeSidesAndUnitOffsets(Crop.l);

      expect(Side.br, equals(sidesAndUnitOffsets[0][0]));

      expect(
          equals5(sidesAndUnitOffsets[0][1], const [
            Offset(0, 0.0),
            Offset(0.86603, -0.5),
            Offset(0.86603, 0.5),
            Offset(0, 1.0),
          ]),
          true);

      expect(Side.t, equals(sidesAndUnitOffsets[1][0]));

      expect(
          equals5(sidesAndUnitOffsets[1][1], const [
            Offset(0, 0.0),
            Offset(0, -1.0),
            Offset(0.86603, -0.5),
          ]),
          true);
    });

    test('dl', () {
      final sidesAndUnitOffsets = getCubeSidesAndUnitOffsets(Crop.dl);

      expect(Side.br, equals(sidesAndUnitOffsets[0][0]));

      expect(
          equals5(sidesAndUnitOffsets[0][1], const [
            Offset(0, 0.0),
            Offset(0.86603, -0.5),
            Offset(0.86603, 0.5),
          ]),
          true);

      expect(Side.t, equals(sidesAndUnitOffsets[1][0]));

      expect(
          equals5(sidesAndUnitOffsets[1][1], const [
            Offset(0, 0.0),
            Offset(-0.86602, -0.5),
            Offset(0, -1.0),
            Offset(0.86603, -0.5),
          ]),
          true);
    });

    test('dr', () {
      final sidesAndUnitOffsets = getCubeSidesAndUnitOffsets(Crop.dr);

      // out(sidesAndUnitOffsets[0][1]);
      // out(sidesAndUnitOffsets[1][1]);

      expect(Side.bl, equals(sidesAndUnitOffsets[0][0]));
      expect(
          equals5(sidesAndUnitOffsets[0][1], const [
            Offset(0, 0.0),
            Offset(-0.86602, 0.5),
            Offset(-0.86602, -0.5),
          ]),
          true);

      expect(Side.t, equals(sidesAndUnitOffsets[1][0]));
      expect(
          equals5(sidesAndUnitOffsets[1][1], const [
            Offset(0, 0.0),
            Offset(-0.86602, -0.5),
            Offset(0, -1.0),
            Offset(0.86603, -0.5),
          ]),
          true);
    });
  });
}
