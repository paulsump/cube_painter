import 'dart:convert';

import 'package:cube_painter/data/cube_info.dart';
import 'package:cube_painter/data/position.dart';
import 'package:cube_painter/data/slice.dart';
import 'package:cube_painter/out.dart';
import 'package:flutter_test/flutter_test.dart';

const noWarn = out;

void main() {
  const testPosition = Position(1, 2);
  const testCrop = Crop.dl;

  const testCube = CubeInfo(center: testPosition, crop: testCrop);

  group('json', () {
    const testJson = '{"center":{"x":1,"y":2},"sliceIndex":5}';
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
