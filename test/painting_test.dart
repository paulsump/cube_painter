import 'dart:convert';

import 'package:cube_painter/out.dart';
import 'package:cube_painter/persisted/cube_info.dart';
import 'package:cube_painter/persisted/painting.dart';
import 'package:cube_painter/persisted/position.dart';
import 'package:cube_painter/persisted/slice.dart';
import 'package:flutter_test/flutter_test.dart';

const noWarn = out;

void main() {
  group('json empty', () {
    const testJson = '{"cubes":[]}';

    test('load', () {
      Map<String, dynamic> map = jsonDecode(testJson);
      Painting newPainting = Painting.fromJson(map);

      expect(newPainting.cubeInfos.length, equals(0));
    });

    test('load toString()', () {
      Painting newPainting = Painting.fromString(testJson);
      expect(newPainting.cubeInfos.length, equals(0));
    });

    test('save', () {
      final painting = Painting.fromEmpty();
      String newJson = jsonEncode(painting);
      expect(testJson, equals(newJson));
    });

    test('save toString()', () {
      final painting = Painting.fromEmpty();
      String newJson = painting.toString();
      expect(testJson, equals(newJson));
    });
  });

  const testPosition = Position(1, 2);
  const testPosition2 = Position(3, 4);

  const testSlice = Slice.topRight;
  const testSlice2 = Slice.bottomRight;

  const testCube = CubeInfo(center: testPosition, slice: testSlice);
  const testCube2 = CubeInfo(center: testPosition2, slice: testSlice2);

  const testCubeInfos = <CubeInfo>[testCube, testCube2];

  group('json two cubes', () {
    const testJson =
        '{"cubes":[{"center":{"x":1,"y":2},"slice":"topRight"},{"center":{"x":3,"y":4},"slice":"bottomRight"}]}';

    test('load', () {
      Map<String, dynamic> map = jsonDecode(testJson);
      Painting newPainting = Painting.fromJson(map);

      int i = 0;
      for (final newCube in newPainting.cubeInfos) {
        expect(testCubeInfos[i++], equals(newCube));
      }
    });

    test('load toString()', () {
      Painting newPainting = Painting.fromString(testJson);

      int i = 0;
      for (final newCube in newPainting.cubeInfos) {
        expect(testCubeInfos[i++], equals(newCube));
      }
    });

    test('save', () {
      const painting = Painting(cubeInfos: testCubeInfos);
      String newJson = jsonEncode(painting);
      expect(testJson, equals(newJson));
    });

    test('save toString()', () {
      const painting = Painting(cubeInfos: testCubeInfos);
      String newJson = painting.toString();
      expect(testJson, equals(newJson));
    });
  });
}