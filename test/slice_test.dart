// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'dart:convert';

import 'package:cube_painter/persisted/slice.dart';
import 'package:flutter_test/flutter_test.dart';

/// Test serialization of [Slice]s.
void main() {
  const testSlice = Slice.topRight;

  group('json', () {
    test('load', () {
      int index = jsonDecode('5');

      final newSlice = Slice.values[index];
      expect(testSlice, equals(newSlice));
    });

    test('save', () {
      String json = jsonEncode(testSlice.index);
      expect('5', equals(json));
    });
  });
}
