// import 'dart:convert';
//
// import 'package:cube_painter/model/crop_direction.dart';
// import 'package:cube_painter/model/grid_point.dart';
// import 'package:cube_painter/shared/cube_corners.dart';
// import 'package:cube_painter/shared/out.dart';
// import 'package:cube_painter/shared/side.dart';
// import 'package:flutter_test/flutter_test.dart';
//
// import 'equals5.dart';
//
// const noWarn = out;
// const testPoint = GridPoint(1, 2);
// const testCube = SimpleCube(testPoint, testCrop);
//
// void main() {
//   group('json', () {
//     test('load', () {
//       Map<String, dynamic> map = jsonDecode('{"x":1,"y":2}');
//       var newPoint = GridPoint.fromJson(map);
//       out(newPoint);
//       expect(testPoint == newPoint, true);
//     });
//     test('save', () {
//       String json = jsonEncode(testPoint);
//       // out(json);
//       expect('{"x":1,"y":2}' == json, true);
//     });
//   });
// }
