import 'package:cube_painter/model/crop_direction.dart';
import 'package:cube_painter/model/cube_info.dart';
import 'package:cube_painter/model/cube_infos.dart';
import 'package:cube_painter/model/grid_point.dart';
import 'package:cube_painter/out.dart';
import 'package:flutter_test/flutter_test.dart';

const noWarn = out;

void main() {
  const testPoint = GridPoint(1, 2);
  const testPoint2 = GridPoint(3, 4);

  const testCrop = Crop.dl;
  const testCrop2 = Crop.ul;

  const testCube = CubeInfo(center: testPoint, crop: testCrop);
  const testCube2 = CubeInfo(center: testPoint2, crop: testCrop2);

  const testCubes = <CubeInfo>[testCube, testCube2];

  group('json', () {
    test('load', () {
      CubeInfos newCubeInfos = CubeInfos.fromJson(
          '[{"center":{"x":1,"y":2},"cropIndex":5},{"center":{"x":3,"y":4},"cropIndex":3}]');

      int i = 0;
      for (final newCube in newCubeInfos.list) {
        expect(testCubes[i++] == newCube, true);
      }
    });

    test('save', () {
      const cubeInfos = CubeInfos(testCubes);
      String json = cubeInfos.toJson();
      // out(json);
      expect(
          '[{"center":{"x":1,"y":2},"cropIndex":5},{"center":{"x":3,"y":4},"cropIndex":3}]' ==
              json,
          true);
    });
  });
}
