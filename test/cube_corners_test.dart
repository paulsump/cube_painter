import 'package:cube_painter/shared/cube_corners.dart';
import 'package:cube_painter/shared/enums.dart';
import 'package:flutter_test/flutter_test.dart';

import 'equals5.dart';

void main() {
  group('Crop', () {
    test('c', () {
      final vertsAndSides = CubeCorners.getVertsAndSides(Crop.c);

      expect(Vert.bl == vertsAndSides[0][0], true);
      expect(
          equals5(vertsAndSides[0][1], const [
            Offset(0, 0.0),
            Offset(0, 1.0),
            Offset(-0.86602, 0.5),
            Offset(-0.86602, -0.5),
          ]),
          true);

      expect(Vert.t == vertsAndSides[1][0], true);
      expect(
          equals5(vertsAndSides[1][1], const [
            Offset(0, 0.0),
            Offset(-0.86602, -0.5),
            Offset(0, -1.0),
            Offset(0.86603, -0.5),
          ]),
          true);

      expect(Vert.br == vertsAndSides[2][0], true);
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

      expect(Vert.t == vertsAndSides[0][0], true);
      expect(
          equals5(vertsAndSides[0][1], const [
            Offset(0, 0.0),
            Offset(-0.86602, -0.5),
            Offset(0, -1.0),
          ]),
          true);

      expect(Vert.bl == vertsAndSides[1][0], true);
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

      expect(Vert.bl == vertsAndSides[0][0], true);

      expect(
          equals5(vertsAndSides[0][1], const [
            Offset(0, 0.0),
            Offset(0, 1.0),
            Offset(-0.86602, 0.5),
            Offset(-0.86602, -0.5),
          ]),
          true);

      expect(Vert.br == vertsAndSides[1][0], true);
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

      expect(Vert.bl == vertsAndSides[0][0], true);

      expect(
          equals5(vertsAndSides[0][1], const [
            Offset(0, 0.0),
            Offset(0, 1.0),
            Offset(-0.86602, 0.5),
          ]),
          true);

      expect(Vert.br == vertsAndSides[1][0], true);

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

      expect(Vert.br == vertsAndSides[0][0], true);

      expect(
          equals5(vertsAndSides[0][1], const [
            Offset(0, 0.0),
            Offset(0.86603, -0.5),
            Offset(0.86603, 0.5),
            Offset(0, 1.0),
          ]),
          true);

      expect(Vert.t == vertsAndSides[1][0], true);

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

      expect(Vert.br == vertsAndSides[0][0], true);

      expect(
          equals5(vertsAndSides[0][1], const [
            Offset(0, 0.0),
            Offset(0.86603, -0.5),
            Offset(0.86603, 0.5),
          ]),
          true);

      expect(Vert.t == vertsAndSides[1][0], true);

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

      expect(Vert.bl == vertsAndSides[0][0], true);
      expect(
          equals5(vertsAndSides[0][1], const [
            Offset(0, 0.0),
            Offset(-0.86602, 0.5),
            Offset(-0.86602, -0.5),
          ]),
          true);

      expect(Vert.t == vertsAndSides[1][0], true);
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
