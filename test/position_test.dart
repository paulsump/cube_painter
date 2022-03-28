// Copyright (c) 2022, Paul Sumpner.  All rights reserved.

import 'dart:convert';

import 'package:cube_painter/persisted/position.dart';
import 'package:flutter_test/flutter_test.dart';

/// Test serialization of [Position]s.
void main() {
  group('json', () {
    const testPosition = Position(1, 2);
    const testJson = '{"x":1,"y":2}';

    test('load', () {
      Map<String, dynamic> map = jsonDecode(testJson);
      final newPosition = Position.fromJson(map);
      // out(newPosition);
      expect(testPosition, equals(newPosition));
    });

    test('save', () {
      String newJson = jsonEncode(testPosition);
      // out(newJson);
      expect(testJson, equals(newJson));
    });
  });
}
