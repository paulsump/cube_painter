// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'dart:convert';

import 'package:cube_painter/persisted/cube_info.dart';
import 'package:cube_painter/persisted/position.dart';
import 'package:cube_painter/persisted/slice.dart';
import 'package:flutter_test/flutter_test.dart';

/// Test serialization of [CubeInfo]s.
void main() {
  const testPosition = Position(1, 2);

  group('json with slice', () {
    const testSlice = Slice.topRight;

    const testCube = CubeInfo(center: testPosition, slice: testSlice);
    const testJson = '{"center":{"x":1,"y":2},"slice":"topRight"}';

    test('load', () {
      Map<String, dynamic> map = jsonDecode(testJson);

      final newCube = CubeInfo.fromJson(map);
      expect(testCube, equals(newCube));
    });

    test('save', () {
      String newJson = jsonEncode(testCube);
      expect(testJson, equals(newJson));
    });
  });

  group('json with no slice', () {
    const testSlice = Slice.whole;

    const testCube = CubeInfo(center: testPosition, slice: testSlice);
    const testJson = '{"center":{"x":1,"y":2}}';

    test('load', () {
      Map<String, dynamic> map = jsonDecode(testJson);

      final newCube = CubeInfo.fromJson(map);
      expect(testCube, equals(newCube));
    });

    test('save', () {
      String newJson = jsonEncode(testCube);
      expect(testJson, equals(newJson));
    });
  });
}
