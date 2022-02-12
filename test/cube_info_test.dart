import 'dart:convert';

import 'package:cube_painter/data/crop.dart';
import 'package:cube_painter/data/cube_info.dart';
import 'package:cube_painter/data/grid_point.dart';
import 'package:cube_painter/out.dart';
import 'package:flutter_test/flutter_test.dart';

const noWarn = out;

void main() {
  const testPoint = Position(1, 2);
  const testCrop = Crop.dl;

  const testCube = CubeInfo(center: testPoint, crop: testCrop);

  group('json', () {
    const testJson = '{"center":{"x":1,"y":2},"cropIndex":5}';
    test('load', () {
      Map<String, dynamic> map = jsonDecode(testJson);

      final newCube = CubeInfo.fromJson(map);
      // out(newCube);
      expect(testCube, equals(newCube));
    });

    test('save', () {
      String newJson = jsonEncode(testCube);
      // out(newJson);
      expect(testJson, equals(newJson));
    });
  });
}
