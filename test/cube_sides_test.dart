import 'package:cube_painter/buttons/hexagon.dart';
import 'package:cube_painter/cubes/cube_sides.dart';
import 'package:cube_painter/cubes/side.dart';
import 'package:cube_painter/data/crop.dart';
import 'package:cube_painter/transform/position_to_unit.dart';
import 'package:flutter_test/flutter_test.dart';

bool equalsOffsetList(List<Offset> a, List<Offset> b) {
  final int n = a.length;

  if (n != b.length) {
    return false;
  }
  for (int i = 0; i < n; ++i) {
    if (!_equalsOffset(a[i], b[i])) {
      return false;
    }
  }
  return true;
}

bool _equalsDouble(double a, double b) {
  return (a - b).abs() == 0.0;
}

bool _equalsOffset(Offset a, Offset b) {
  return _equalsDouble(a.dx, b.dx) && _equalsDouble(a.dy, b.dy);
}

void main() {
  group('Testing calcHexagonOffsets()', () {
    const double x = root3over2;
    const double y = 0.5;

    test('offset 0', () {
      final List<Offset> offsets = getHexagonCornerOffsets();
      final offset = const Offset(x, -y) + unit;
      expect(offsets[0].dx, equals(offset.dx));
      expect(offsets[0].dy, equals(offset.dy));
    });
    test('offset 1', () {
      final List<Offset> offsets = getHexagonCornerOffsets();
      final offset = const Offset(0.0, -1.0) + unit;
      expect(offsets[1].dx, equals(offset.dx));
      expect(offsets[1].dy, equals(offset.dy));
    });
    test('offset 2', () {
      final List<Offset> offsets = getHexagonCornerOffsets();
      final offset = const Offset(-x, -y) + unit;
      expect(offsets[2].dx, equals(offset.dx));
      expect(offsets[2].dy, equals(offset.dy));
    });
    test('offset 3', () {
      final List<Offset> offsets = getHexagonCornerOffsets();
      final offset = const Offset(-x, y) + unit;
      expect(offsets[3].dx, equals(offset.dx));
      expect(offsets[3].dy, equals(offset.dy));
    });
    test('offset 4', () {
      final List<Offset> offsets = getHexagonCornerOffsets();
      final offset = const Offset(0.0, 1.0) + unit;
      expect(offsets[4].dx, equals(offset.dx));
      expect(offsets[4].dy, equals(offset.dy));
    });
    test('offset 5', () {
      final List<Offset> offsets = getHexagonCornerOffsets();
      final offset = const Offset(x, y) + unit;
      expect(offsets[5].dx, equals(offset.dx));
      expect(offsets[5].dy, equals(offset.dy));
    });
  });

  group('Crop', () {
    test('c', () {
      final sidesAndUnitOffsets = getCubeSidesAndUnitOffsets(Crop.c);

      expect(Side.bl, equals(sidesAndUnitOffsets[0][0]));
      expect(
          equalsOffsetList(sidesAndUnitOffsets[0][1], const [
            Offset(0, 0.0),
            Offset(0, 1.0),
            Offset(-root3over2, 0.5),
            Offset(-root3over2, -0.5),
          ]),
          true);

      expect(Side.t, equals(sidesAndUnitOffsets[1][0]));
      expect(
          equalsOffsetList(sidesAndUnitOffsets[1][1], topSide), true);

      expect(Side.br, equals(sidesAndUnitOffsets[2][0]));
      expect(
          equalsOffsetList(sidesAndUnitOffsets[2][1], const [
            Offset(0, 0.0),
            Offset(root3over2, -0.5),
            Offset(root3over2, 0.5),
            Offset(0, 1.0),
          ]),
          true);
    });

    test('r', () {
      final sidesAndUnitOffsets = getCubeSidesAndUnitOffsets(Crop.r);

      expect(Side.t, equals(sidesAndUnitOffsets[0][0]));
      expect(
          equalsOffsetList(sidesAndUnitOffsets[0][1], const [
            Offset(0, 0.0),
            Offset(-root3over2, -0.5),
            Offset(0, -1.0),
          ]),
          true);

      expect(Side.bl, equals(sidesAndUnitOffsets[1][0]));
      expect(
          equalsOffsetList(sidesAndUnitOffsets[1][1], const [
            Offset(0, 0.0),
            Offset(0, 1.0),
            Offset(-root3over2, 0.5),
            Offset(-root3over2, -0.5),
          ]),
          true);
    });

    test('ur', () {
      final sidesAndUnitOffsets = getCubeSidesAndUnitOffsets(Crop.ur);

      expect(Side.bl, equals(sidesAndUnitOffsets[0][0]));

      expect(
          equalsOffsetList(sidesAndUnitOffsets[0][1], const [
            Offset(0, 0.0),
            Offset(0, 1.0),
            Offset(-root3over2, 0.5),
            Offset(-root3over2, -0.5),
          ]),
          true);

      expect(Side.br, equals(sidesAndUnitOffsets[1][0]));
      expect(
          equalsOffsetList(sidesAndUnitOffsets[1][1], const [
            Offset(0, 0.0),
            Offset(root3over2, 0.5),
            Offset(0, 1.0),
          ]),
          true);
    });

    test('ul', () {
      final sidesAndUnitOffsets = getCubeSidesAndUnitOffsets(Crop.ul);

      expect(Side.bl, equals(sidesAndUnitOffsets[0][0]));

      expect(
          equalsOffsetList(sidesAndUnitOffsets[0][1], const [
            Offset(0, 0.0),
            Offset(0, 1.0),
            Offset(-root3over2, 0.5),
          ]),
          true);

      expect(Side.br, equals(sidesAndUnitOffsets[1][0]));

      expect(
          equalsOffsetList(sidesAndUnitOffsets[1][1], const [
            Offset(0, 0.0),
            Offset(root3over2, -0.5),
            Offset(root3over2, 0.5),
            Offset(0, 1.0),
          ]),
          true);
    });

    test('l', () {
      final sidesAndUnitOffsets = getCubeSidesAndUnitOffsets(Crop.l);

      expect(Side.br, equals(sidesAndUnitOffsets[0][0]));

      expect(
          equalsOffsetList(sidesAndUnitOffsets[0][1], const [
            Offset(0, 0.0),
            Offset(root3over2, -0.5),
            Offset(root3over2, 0.5),
            Offset(0, 1.0),
          ]),
          true);

      expect(Side.t, equals(sidesAndUnitOffsets[1][0]));

      expect(
          equalsOffsetList(sidesAndUnitOffsets[1][1], const [
            Offset(0, 0.0),
            Offset(0, -1.0),
            Offset(root3over2, -0.5),
          ]),
          true);
    });

    test('dl', () {
      final sidesAndUnitOffsets = getCubeSidesAndUnitOffsets(Crop.dl);

      expect(Side.br, equals(sidesAndUnitOffsets[0][0]));

      expect(
          equalsOffsetList(sidesAndUnitOffsets[0][1], const [
            Offset(0, 0.0),
            Offset(root3over2, -0.5),
            Offset(root3over2, 0.5),
          ]),
          true);

      expect(Side.t, equals(sidesAndUnitOffsets[1][0]));

      expect(
          equalsOffsetList(sidesAndUnitOffsets[1][1], const [
            Offset(0, 0.0),
            Offset(-root3over2, -0.5),
            Offset(0, -1.0),
            Offset(root3over2, -0.5),
          ]),
          true);
    });

    test('dr', () {
      final sidesAndUnitOffsets = getCubeSidesAndUnitOffsets(Crop.dr);

      // out(sidesAndUnitOffsets[0][1]);
      // out(sidesAndUnitOffsets[1][1]);

      expect(Side.bl, equals(sidesAndUnitOffsets[0][0]));
      expect(
          equalsOffsetList(sidesAndUnitOffsets[0][1], const [
            Offset(0, 0.0),
            Offset(-root3over2, 0.5),
            Offset(-root3over2, -0.5),
          ]),
          true);

      expect(Side.t, equals(sidesAndUnitOffsets[1][0]));
      expect(
          equalsOffsetList(sidesAndUnitOffsets[1][1], const [
            Offset(0, 0.0),
            Offset(-root3over2, -0.5),
            Offset(0, -1.0),
            Offset(root3over2, -0.5),
          ]),
          true);
    });
  });
}
