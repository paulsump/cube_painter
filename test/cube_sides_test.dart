import 'package:cube_painter/cubes/cube_sides.dart';
import 'package:cube_painter/cubes/side.dart';
import 'package:cube_painter/data/crop.dart';
import 'package:flutter_test/flutter_test.dart';

import 'equals5.dart';

void main() {
  group('Crop', () {
    test('c', () {
      final sidesAndPoints = getCubeSidePoints(Crop.c);

      expect(Side.bl, equals(sidesAndPoints[0][0]));
      expect(
          equals5(sidesAndPoints[0][1], const [
            Offset(0, 0.0),
            Offset(0, 1.0),
            Offset(-0.86602, 0.5),
            Offset(-0.86602, -0.5),
          ]),
          true);

      expect(Side.t, equals(sidesAndPoints[1][0]));
      expect(
          equals5(sidesAndPoints[1][1], const [
            Offset(0, 0.0),
            Offset(-0.86602, -0.5),
            Offset(0, -1.0),
            Offset(0.86603, -0.5),
          ]),
          true);

      expect(Side.br, equals(sidesAndPoints[2][0]));
      expect(
          equals5(sidesAndPoints[2][1], const [
            Offset(0, 0.0),
            Offset(0.86603, -0.5),
            Offset(0.86603, 0.5),
            Offset(0, 1.0),
          ]),
          true);
    });

    test('r', () {
      final sidesAndPoints = getCubeSidePoints(Crop.r);

      expect(Side.t, equals(sidesAndPoints[0][0]));
      expect(
          equals5(sidesAndPoints[0][1], const [
            Offset(0, 0.0),
            Offset(-0.86602, -0.5),
            Offset(0, -1.0),
          ]),
          true);

      expect(Side.bl, equals(sidesAndPoints[1][0]));
      expect(
          equals5(sidesAndPoints[1][1], const [
            Offset(0, 0.0),
            Offset(0, 1.0),
            Offset(-0.86602, 0.5),
            Offset(-0.86602, -0.5),
          ]),
          true);
    });

    test('ur', () {
      final sidesAndPoints = getCubeSidePoints(Crop.ur);

      expect(Side.bl, equals(sidesAndPoints[0][0]));

      expect(
          equals5(sidesAndPoints[0][1], const [
            Offset(0, 0.0),
            Offset(0, 1.0),
            Offset(-0.86602, 0.5),
            Offset(-0.86602, -0.5),
          ]),
          true);

      expect(Side.br, equals(sidesAndPoints[1][0]));
      expect(
          equals5(sidesAndPoints[1][1], const [
            Offset(0, 0.0),
            Offset(0.86603, 0.5),
            Offset(0, 1.0),
          ]),
          true);
    });

    test('ul', () {
      final sidesAndPoints = getCubeSidePoints(Crop.ul);

      expect(Side.bl, equals(sidesAndPoints[0][0]));

      expect(
          equals5(sidesAndPoints[0][1], const [
            Offset(0, 0.0),
            Offset(0, 1.0),
            Offset(-0.86602, 0.5),
          ]),
          true);

      expect(Side.br, equals(sidesAndPoints[1][0]));

      expect(
          equals5(sidesAndPoints[1][1], const [
            Offset(0, 0.0),
            Offset(0.86603, -0.5),
            Offset(0.86603, 0.5),
            Offset(0, 1.0),
          ]),
          true);
    });

    test('l', () {
      final sidesAndPoints = getCubeSidePoints(Crop.l);

      expect(Side.br, equals(sidesAndPoints[0][0]));

      expect(
          equals5(sidesAndPoints[0][1], const [
            Offset(0, 0.0),
            Offset(0.86603, -0.5),
            Offset(0.86603, 0.5),
            Offset(0, 1.0),
          ]),
          true);

      expect(Side.t, equals(sidesAndPoints[1][0]));

      expect(
          equals5(sidesAndPoints[1][1], const [
            Offset(0, 0.0),
            Offset(0, -1.0),
            Offset(0.86603, -0.5),
          ]),
          true);
    });

    test('dl', () {
      final sidesAndPoints = getCubeSidePoints(Crop.dl);

      expect(Side.br, equals(sidesAndPoints[0][0]));

      expect(
          equals5(sidesAndPoints[0][1], const [
            Offset(0, 0.0),
            Offset(0.86603, -0.5),
            Offset(0.86603, 0.5),
          ]),
          true);

      expect(Side.t, equals(sidesAndPoints[1][0]));

      expect(
          equals5(sidesAndPoints[1][1], const [
            Offset(0, 0.0),
            Offset(-0.86602, -0.5),
            Offset(0, -1.0),
            Offset(0.86603, -0.5),
          ]),
          true);
    });

    test('dr', () {
      final sidesAndPoints = getCubeSidePoints(Crop.dr);

      // out(sidesAndPoints[0][1]);
      // out(sidesAndPoints[1][1]);

      expect(Side.bl, equals(sidesAndPoints[0][0]));
      expect(
          equals5(sidesAndPoints[0][1], const [
            Offset(0, 0.0),
            Offset(-0.86602, 0.5),
            Offset(-0.86602, -0.5),
          ]),
          true);

      expect(Side.t, equals(sidesAndPoints[1][0]));
      expect(
          equals5(sidesAndPoints[1][1], const [
            Offset(0, 0.0),
            Offset(-0.86602, -0.5),
            Offset(0, -1.0),
            Offset(0.86603, -0.5),
          ]),
          true);
    });
  });
}
