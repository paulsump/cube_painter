import 'dart:convert';

import 'package:cube_painter/model/crop_direction.dart';
import 'package:cube_painter/model/grid_point.dart';
import 'package:cube_painter/model/cube_data.dart';
import 'package:cube_painter/shared/cube_corners.dart';
import 'package:cube_painter/shared/out.dart';
import 'package:cube_painter/shared/side.dart';
import 'package:cube_painter/widgets/simple_cube.dart';
import 'package:flutter_test/flutter_test.dart';

import 'equals5.dart';

const noWarn = out;
const testPoint = GridPoint(1, 2);
const testCrop = Crop.dl;

const testCube = SimpleCube(testPoint, testCrop);

void main() {
  group('json', () {
    test('load', () {
      Map<String, dynamic> map =
          jsonDecode('{"center":{"x":1,"y":2},"cropIndex":5}');
      var newCube = SimpleCube.fromJson(map);
      out(newCube);
      expect(testCube == newCube, true);
    });
    test('save', () {
      String json = jsonEncode(testCube);
      // out(json);
      expect('{"center":{"x":1,"y":2},"cropIndex":5}' == json, true);
    });
  });
}
