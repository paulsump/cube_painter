import 'dart:convert';

import 'package:cube_painter/data/crop.dart';
import 'package:cube_painter/out.dart';
import 'package:flutter_test/flutter_test.dart';

const noWarn = out;
const testCrop = Crop.dl;

void main() {
  group('json', () {
    test('load', () {
      int index = jsonDecode('5');
      out(index);
      final newCrop = Crop.values[index];
      out(newCrop);
      expect(testCrop, equals(newCrop));
    });
    test('save', () {
      String json = jsonEncode(testCrop.index);
      out(json);
      expect('5', equals(json));
    });
  });
}
