import 'dart:convert';

import 'package:cube_painter/model/crop_direction.dart';
import 'package:cube_painter/shared/out.dart';
import 'package:flutter_test/flutter_test.dart';

const noWarn = out;
const testCrop = Crop.dl;

void main() {
  group('json', () {
    // test('load', () {
    //   Map<String, dynamic> map = jsonDecode('{"x":1,"y":2}');
    //   final newCrop = Crop.fromJson(map);
    //   out(newCrop);
    //   expect(testCrop == newCrop, true);
    // });
    test('save', () {
      String json = jsonEncode(testCrop);
      out(json);
      expect('{"x":1,"y":2}' == json, true);
    });
  });
}
