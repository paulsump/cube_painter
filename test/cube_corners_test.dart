import 'package:cube_painter/cubes/cube_corners.dart';
import 'package:cube_painter/cubes/side.dart';
import 'package:cube_painter/data/crop.dart';
import 'package:flutter_test/flutter_test.dart';

import 'equals5.dart';

void main() {
  group('Crop', () {
    test('c', () {
      final vertsAndSides = CubeCorners.getVertsAndSides(Crop.c);

      expect(Side.bl, equals(vertsAndSides[0][0]));
      expect(
          equals5(vertsAndSides[0][1], const [
            Offset(0, 0.0),
            Offset(0, 1.0),
            Offset(-0.86602, 0.5),
            Offset(-0.86602, -0.5),
          ]),
          true);

      expect(Side.t, equals(vertsAndSides[1][0]));
      expect(
          equals5(vertsAndSides[1][1], const [
            Offset(0, 0.0),
            Offset(-0.86602, -0.5),
            Offset(0, -1.0),
            Offset(0.86603, -0.5),
          ]),
          true);

      expect(Side.br, equals(vertsAndSides[2][0]));
      expect(
          equals5(vertsAndSides[2][1], const [
            Offset(0, 0.0),
            Offset(0.86603, -0.5),
            Offset(0.86603, 0.5),
            Offset(0, 1.0),
          ]),
          true);
    });

    test('r', () {
      final vertsAndSides = CubeCorners.getVertsAndSides(Crop.r);

      expect(Side.t, equals(vertsAndSides[0][0]));
      expect(
          equals5(vertsAndSides[0][1], const [
            Offset(0, 0.0),
            Offset(-0.86602, -0.5),
            Offset(0, -1.0),
          ]),
          true);

      expect(Side.bl, equals(vertsAndSides[1][0]));
      expect(
          equals5(vertsAndSides[1][1], const [
            Offset(0, 0.0),
            Offset(0, 1.0),
            Offset(-0.86602, 0.5),
            Offset(-0.86602, -0.5),
          ]),
          true);
    });

    test('ur', () {
      final vertsAndSides = CubeCorners.getVertsAndSides(Crop.ur);

      expect(Side.bl, equals(vertsAndSides[0][0]));

      expect(
          equals5(vertsAndSides[0][1], const [
            Offset(0, 0.0),
            Offset(0, 1.0),
            Offset(-0.86602, 0.5),
            Offset(-0.86602, -0.5),
          ]),
          true);

      expect(Side.br, equals(vertsAndSides[1][0]));
      expect(
          equals5(vertsAndSides[1][1], const [
            Offset(0, 0.0),
            Offset(0.86603, 0.5),
            Offset(0, 1.0),
          ]),
          true);
    });

    test('ul', () {
      final vertsAndSides = CubeCorners.getVertsAndSides(Crop.ul);

      expect(Side.bl, equals(vertsAndSides[0][0]));

      expect(
          equals5(vertsAndSides[0][1], const [
            Offset(0, 0.0),
            Offset(0, 1.0),
            Offset(-0.86602, 0.5),
          ]),
          true);

      expect(Side.br, equals(vertsAndSides[1][0]));

      expect(
          equals5(vertsAndSides[1][1], const [
            Offset(0, 0.0),
            Offset(0.86603, -0.5),
            Offset(0.86603, 0.5),
            Offset(0, 1.0),
          ]),
          true);
    });

    test('l', () {
      final vertsAndSides = CubeCorners.getVertsAndSides(Crop.l);

      expect(Side.br, equals(vertsAndSides[0][0]));

      expect(
          equals5(vertsAndSides[0][1], const [
            Offset(0, 0.0),
            Offset(0.86603, -0.5),
            Offset(0.86603, 0.5),
            Offset(0, 1.0),
          ]),
          true);

      expect(Side.t, equals(vertsAndSides[1][0]));

      expect(
          equals5(vertsAndSides[1][1], const [
            Offset(0, 0.0),
            Offset(0, -1.0),
            Offset(0.86603, -0.5),
          ]),
          true);
    });

    test('dl', () {
      final vertsAndSides = CubeCorners.getVertsAndSides(Crop.dl);

      expect(Side.br, equals(vertsAndSides[0][0]));

      expect(
          equals5(vertsAndSides[0][1], const [
            Offset(0, 0.0),
            Offset(0.86603, -0.5),
            Offset(0.86603, 0.5),
          ]),
          true);

      expect(Side.t, equals(vertsAndSides[1][0]));

      expect(
          equals5(vertsAndSides[1][1], const [
            Offset(0, 0.0),
            Offset(-0.86602, -0.5),
            Offset(0, -1.0),
            Offset(0.86603, -0.5),
          ]),
          true);
    });

    test('dr', () {
      final vertsAndSides = CubeCorners.getVertsAndSides(Crop.dr);

      // out(vertsAndSides[0][1]);
      // out(vertsAndSides[1][1]);

      expect(Side.bl, equals(vertsAndSides[0][0]));
      expect(
          equals5(vertsAndSides[0][1], const [
            Offset(0, 0.0),
            Offset(-0.86602, 0.5),
            Offset(-0.86602, -0.5),
          ]),
          true);

      expect(Side.t, equals(vertsAndSides[1][0]));
      expect(
          equals5(vertsAndSides[1][1], const [
            Offset(0, 0.0),
            Offset(-0.86602, -0.5),
            Offset(0, -1.0),
            Offset(0.86603, -0.5),
          ]),
          true);
    });
  });
}
