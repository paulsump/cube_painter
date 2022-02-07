import 'dart:convert';

import 'package:cube_painter/model/grid_point.dart';
import 'package:cube_painter/shared/out.dart';
import 'package:flutter_test/flutter_test.dart';

const noWarn = out;
const testPoint = GridPoint(1, 2);

void main() {
  group('json', () {
    test('load', () {
      Map<String, dynamic> map = jsonDecode('{"x":1,"y":2}');
      final newPoint = GridPoint.fromJson(map);
      // out(newPoint);
      expect(testPoint == newPoint, true);
    });
    test('save', () {
      String json = jsonEncode(testPoint);
      // out(json);
      expect('{"x":1,"y":2}' == json, true);
    });
  });
}
