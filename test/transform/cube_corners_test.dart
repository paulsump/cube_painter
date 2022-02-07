import 'package:cube_painter/model/crop_direction.dart';
import 'package:cube_painter/rendering/cube_corners.dart';
import 'package:cube_painter/rendering/side.dart';
import 'package:flutter_test/flutter_test.dart';

import '../equals5.dart';

void main() {
  group('Crop', () {
    test('c', () {
      final vertsAndSides = CubeCorners.getVertsAndSides(Crop.c);

      expect(Side.bl == vertsAndSides[0][0], true);
      expect(
          equals5(vertsAndSides[0][1], const [
            Offset(0, 0.0),
            Offset(0, 1.0),
            Offset(-0.86602, 0.5),
            Offset(-0.86602, -0.5),
          ]),
          true);

      expect(Side.t == vertsAndSides[1][0], true);
      expect(
          equals5(vertsAndSides[1][1], const [
            Offset(0, 0.0),
            Offset(-0.86602, -0.5),
            Offset(0, -1.0),
            Offset(0.86603, -0.5),
          ]),
          true);

      expect(Side.br == vertsAndSides[2][0], true);
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

      expect(Side.t == vertsAndSides[0][0], true);
      expect(
          equals5(vertsAndSides[0][1], const [
            Offset(0, 0.0),
            Offset(-0.86602, -0.5),
            Offset(0, -1.0),
          ]),
          true);

      expect(Side.bl == vertsAndSides[1][0], true);
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

      expect(Side.bl == vertsAndSides[0][0], true);

      expect(
          equals5(vertsAndSides[0][1], const [
            Offset(0, 0.0),
            Offset(0, 1.0),
            Offset(-0.86602, 0.5),
            Offset(-0.86602, -0.5),
          ]),
          true);

      expect(Side.br == vertsAndSides[1][0], true);
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

      expect(Side.bl == vertsAndSides[0][0], true);

      expect(
          equals5(vertsAndSides[0][1], const [
            Offset(0, 0.0),
            Offset(0, 1.0),
            Offset(-0.86602, 0.5),
          ]),
          true);

      expect(Side.br == vertsAndSides[1][0], true);

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

      expect(Side.br == vertsAndSides[0][0], true);

      expect(
          equals5(vertsAndSides[0][1], const [
            Offset(0, 0.0),
            Offset(0.86603, -0.5),
            Offset(0.86603, 0.5),
            Offset(0, 1.0),
          ]),
          true);

      expect(Side.t == vertsAndSides[1][0], true);

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

      expect(Side.br == vertsAndSides[0][0], true);

      expect(
          equals5(vertsAndSides[0][1], const [
            Offset(0, 0.0),
            Offset(0.86603, -0.5),
            Offset(0.86603, 0.5),
          ]),
          true);

      expect(Side.t == vertsAndSides[1][0], true);

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

      expect(Side.bl == vertsAndSides[0][0], true);
      expect(
          equals5(vertsAndSides[0][1], const [
            Offset(0, 0.0),
            Offset(-0.86602, 0.5),
            Offset(-0.86602, -0.5),
          ]),
          true);

      expect(Side.t == vertsAndSides[1][0], true);
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
