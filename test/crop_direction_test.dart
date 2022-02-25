import 'dart:convert';

import 'package:cube_painter/data/slice.dart';
import 'package:cube_painter/out.dart';
import 'package:flutter_test/flutter_test.dart';

const noWarn = out;
const testSlice = Slice.dl;

void main() {
  group('json', () {
    test('load', () {
      int index = jsonDecode('5');
      out(index);
      final newSlice = Slice.values[index];
      out(newSlice);
      expect(testSlice, equals(newSlice));
    });
    test('save', () {
      String json = jsonEncode(testSlice.index);
      out(json);
      expect('5', equals(json));
    });
  });
}
