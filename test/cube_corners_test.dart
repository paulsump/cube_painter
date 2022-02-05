import 'package:cube_painter/shared/cube_corners.dart';
import 'package:cube_painter/shared/enums.dart';
import 'package:cube_painter/shared/grid_point.dart';
import 'package:cube_painter/shared/grid_transform.dart';
import 'package:flutter_test/flutter_test.dart';

import 'equals5.dart';

void main() {
  const testPoint = GridPoint(2, 2);
  final Offset center = toOffset(testPoint);

  group('Crop', () {
    test('c', () {
      final vertsAndSides = CubeCorners.getVertsAndSides(Crop.c, center);

      expect(Vert.bl == vertsAndSides[0][0], true);
      expect(
          equals5(vertsAndSides[0][1], const [
            Offset(1.73205, 0.0 - 1.0),
            Offset(1.73205, 1.0 - 1.0),
            Offset(0.86603, 0.5 - 1.0),
            Offset(0.86603, -0.5 - 1.0),
          ]),
          true);

      expect(Vert.t == vertsAndSides[1][0], true);
      expect(
          equals5(vertsAndSides[1][1], const [
            Offset(1.73205, 0.0 - 1.0),
            Offset(0.86603, -0.5 - 1.0),
            Offset(1.73205, -1.0 - 1.0),
            Offset(2.59808, -0.5 - 1.0),
          ]),
          true);

      expect(Vert.br == vertsAndSides[2][0], true);
      expect(
          equals5(vertsAndSides[2][1], const [
            Offset(1.73205, 0.0 - 1.0),
            Offset(2.59808, -0.5 - 1.0),
            Offset(2.59808, 0.5 - 1.0),
            Offset(1.73205, 1.0 - 1.0),
          ]),
          true);
    });

    test('r', () {
      final vertsAndSides = CubeCorners.getVertsAndSides(Crop.r, center);

      expect(Vert.t == vertsAndSides[0][0], true);
      expect(
          equals5(vertsAndSides[0][1], const [
            Offset(1.73205, 0.0 - 1.0),
            Offset(0.86603, -0.5 - 1.0),
            Offset(1.73205, -1.0 - 1.0),
          ]),
          true);

      expect(Vert.bl == vertsAndSides[1][0], true);
      expect(
          equals5(vertsAndSides[1][1], const [
            Offset(1.73205, 0.0 - 1.0),
            Offset(1.73205, 1.0 - 1.0),
            Offset(0.86603, 0.5 - 1.0),
            Offset(0.86603, -0.5 - 1.0),
          ]),
          true);
    });

    test('ur', () {
      final vertsAndSides = CubeCorners.getVertsAndSides(Crop.ur, center);

      expect(Vert.bl == vertsAndSides[0][0], true);

      expect(
          equals5(vertsAndSides[0][1], const [
            Offset(1.73205, 0.0 - 1.0),
            Offset(1.73205, 1.0 - 1.0),
            Offset(0.86603, 0.5 - 1.0),
            Offset(0.86603, -0.5 - 1.0),
          ]),
          true);

      expect(Vert.br == vertsAndSides[1][0], true);
      expect(
          equals5(vertsAndSides[1][1], const [
            Offset(1.73205, 0.0 - 1.0),
            Offset(2.59808, 0.5 - 1.0),
            Offset(1.73205, 1.0 - 1.0),
          ]),
          true);
    });

    test('ul', () {
      final vertsAndSides = CubeCorners.getVertsAndSides(Crop.ul, center);

      expect(Vert.bl == vertsAndSides[0][0], true);

      expect(
          equals5(vertsAndSides[0][1], const [
            Offset(1.73205, 0.0 - 1.0),
            Offset(1.73205, 1.0 - 1.0),
            Offset(0.86603, 0.5 - 1.0),
          ]),
          true);

      expect(Vert.br == vertsAndSides[1][0], true);

      expect(
          equals5(vertsAndSides[1][1], const [
            Offset(1.73205, 0.0 - 1.0),
            Offset(2.59808, -0.5 - 1.0),
            Offset(2.59808, 0.5 - 1.0),
            Offset(1.73205, 1.0 - 1.0),
          ]),
          true);
    });

    test('l', () {
      final vertsAndSides = CubeCorners.getVertsAndSides(Crop.l, center);

      expect(Vert.br == vertsAndSides[0][0], true);

      expect(
          equals5(vertsAndSides[0][1], const [
            Offset(1.73205, 0.0 - 1.0),
            Offset(2.59808, -0.5 - 1.0),
            Offset(2.59808, 0.5 - 1.0),
            Offset(1.73205, 1.0 - 1.0),
          ]),
          true);

      expect(Vert.t == vertsAndSides[1][0], true);

      expect(
          equals5(vertsAndSides[1][1], const [
            Offset(1.73205, 0.0 - 1.0),
            Offset(1.73205, -1.0 - 1.0),
            Offset(2.59808, -0.5 - 1.0),
          ]),
          true);
    });

    test('dl', () {
      final vertsAndSides = CubeCorners.getVertsAndSides(Crop.dl, center);

      expect(Vert.br == vertsAndSides[0][0], true);

      expect(
          equals5(vertsAndSides[0][1], const [
            Offset(1.73205, 0.0 - 1.0),
            Offset(2.59808, -0.5 - 1.0),
            Offset(2.59808, 0.5 - 1.0),
          ]),
          true);

      expect(Vert.t == vertsAndSides[1][0], true);

      expect(
          equals5(vertsAndSides[1][1], const [
            Offset(1.73205, 0.0 - 1.0),
            Offset(0.86603, -0.5 - 1.0),
            Offset(1.73205, -1.0 - 1.0),
            Offset(2.59808, -0.5 - 1.0),
          ]),
          true);
    });

    test('dr', () {
      final vertsAndSides = CubeCorners.getVertsAndSides(Crop.dr, center);

      // out(vertsAndSides[0][1]);
      // out(vertsAndSides[1][1]);

      expect(Vert.bl == vertsAndSides[0][0], true);
      expect(
          equals5(vertsAndSides[0][1], const [
            Offset(1.73205, 0.0 - 1.0),
            Offset(0.86603, 0.5 - 1.0),
            Offset(0.86603, -0.5 - 1.0),
          ]),
          true);

      expect(Vert.t == vertsAndSides[1][0], true);
      expect(
          equals5(vertsAndSides[1][1], const [
            Offset(1.73205, 0.0 - 1.0),
            Offset(0.86603, -0.5 - 1.0),
            Offset(1.73205, -1.0 - 1.0),
            Offset(2.59808, -0.5 - 1.0),
          ]),
          true);
    });
  });
}
