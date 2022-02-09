import 'dart:convert';

import 'package:cube_painter/data/crop.dart';
import 'package:cube_painter/data/cube_group.dart';
import 'package:cube_painter/data/cube_info.dart';
import 'package:cube_painter/data/grid_point.dart';
import 'package:cube_painter/out.dart';
import 'package:flutter_test/flutter_test.dart';

const noWarn = out;

void main() {
  group('json empty', () {
    const testJson = '{"list":[]}';

    test('load', () {
      Map<String, dynamic> map = jsonDecode(testJson);
      CubeGroup newCubeGroup = CubeGroup.fromJson(map);

      expect(newCubeGroup.list.length, equals(0));
    });

    test('save', () {
      const cubeGroup = CubeGroup(<CubeInfo>[]);
      String newJson = jsonEncode(cubeGroup);
      out(newJson);
      expect(testJson, equals(newJson));
    });
  });

  const testPoint = GridPoint(1, 2);
  const testPoint2 = GridPoint(3, 4);

  const testCrop = Crop.dl;
  const testCrop2 = Crop.ul;

  const testCube = CubeInfo(center: testPoint, crop: testCrop);
  const testCube2 = CubeInfo(center: testPoint2, crop: testCrop2);

  const testCubes = <CubeInfo>[testCube, testCube2];

  group('json two cubes', () {
    const testJson =
        '{"list":[{"center":{"x":1,"y":2},"cropIndex":5},{"center":{"x":3,"y":4},"cropIndex":3}]}';

    test('load', () {
      Map<String, dynamic> map = jsonDecode(testJson);
      CubeGroup newCubeGroup = CubeGroup.fromJson(map);

      int i = 0;
      for (final newCube in newCubeGroup.list) {
        expect(testCubes[i++], equals(newCube));
      }
    });

    test('save', () {
      const cubeGroup = CubeGroup(testCubes);
      String newJson = jsonEncode(cubeGroup);
      expect(testJson, equals(newJson));
    });
  });
}
