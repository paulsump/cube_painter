import 'dart:convert';

import 'package:cube_painter/model/crop_direction.dart';
import 'package:cube_painter/model/grid_point.dart';
import 'package:flutter/material.dart';

class CubeInfo {
  final GridPoint center;

  final Crop crop;

  const CubeInfo({required this.center, required this.crop});

  @override
  bool operator ==(Object other) =>
      other is CubeInfo ? center == other.center && crop == other.crop : false;

  @override
  int get hashCode => hashValues(center, crop);

  @override
  String toString() => '$center,$crop';

  CubeInfo.fromJson(Map<String, dynamic> json)
      : center = GridPoint.fromJson(json['center']),
        crop = Crop.values[json['cropIndex']];

  Map<String, dynamic> toJson() => {'center': center, 'cropIndex': crop.index};

  /// for load
  static Iterable<CubeInfo> listFromJson(String json) sync* {
    for (final cubeInfoObject in jsonDecode(json)) {
      yield CubeInfo.fromJson(cubeInfoObject);
    }
  }

  /// for save
  static String jsonFromList(List<CubeInfo> cubes) {
    return jsonEncode(cubes);
  }
}