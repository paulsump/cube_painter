import 'dart:convert';

import 'package:cube_painter/model/crop_direction.dart';
import 'package:cube_painter/model/cube_info.dart';
import 'package:cube_painter/model/grid_point.dart';
import 'package:cube_painter/shared/out.dart';
import 'package:flutter_test/flutter_test.dart';

const noWarn = out;

void main() {
  const testPoint = GridPoint(1, 2);
  const testCrop = Crop.dl;

  const testCube = CubeInfo(center: testPoint, crop: testCrop);

  group('json', () {
    test('load', () {
      Map<String, dynamic> map =
          jsonDecode('{"center":{"x":1,"y":2},"cropIndex":5}');

      final newCube = CubeInfo.fromJson(map);
      // out(newCube);
      expect(testCube == newCube, true);
    });

    test('save', () {
      String json = jsonEncode(testCube);
      // out(json);
      expect('{"center":{"x":1,"y":2},"cropIndex":5}' == json, true);
    });
  });

  const testPoint2 = GridPoint(3, 4);
  const testCrop2 = Crop.ul;

  const testCube2 = CubeInfo(center: testPoint2, crop: testCrop2);

  const testCubes = <CubeInfo>[testCube, testCube2];

  group('json of list', () {
    test('load', () {
      List newCubes = jsonDecode(
          '[{"center":{"x":1,"y":2},"cropIndex":5},{"center":{"x":3,"y":4},"cropIndex":3}]');

      int i = 0;
      for (final cubeInfoObject in newCubes) {
        final newCube = CubeInfo.fromJson(cubeInfoObject);
        expect(testCubes[i++] == newCube, true);
      }
    });

    test('save', () {
      String json = jsonEncode(testCubes);
      // out(json);
      expect(
          '[{"center":{"x":1,"y":2},"cropIndex":5},{"center":{"x":3,"y":4},"cropIndex":3}]' ==
              json,
          true);
    });
  });
}
