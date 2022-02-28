import 'dart:convert';

import 'package:cube_painter/persisted/slice.dart';
import 'package:cube_painter/out.dart';
import 'package:flutter_test/flutter_test.dart';

const noWarn = out;
const testSlice = Slice.topRight;

void main() {
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
