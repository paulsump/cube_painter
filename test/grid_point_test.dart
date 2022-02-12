import 'dart:convert';

import 'package:cube_painter/data/position.dart';
import 'package:cube_painter/out.dart';
import 'package:flutter_test/flutter_test.dart';

const noWarn = out;
const testPoint = Position(1, 2);

void main() {
  group('json', () {
    const testJson = '{"x":1,"y":2}';

    test('load', () {
      Map<String, dynamic> map = jsonDecode(testJson);
      final newPoint = Position.fromJson(map);
      // out(newPoint);
      expect(testPoint, equals(newPoint));
    });

    test('save', () {
      String newJson = jsonEncode(testPoint);
      // out(newJson);
      expect(testJson, equals(newJson));
    });
  });
}
