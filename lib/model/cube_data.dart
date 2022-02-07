import 'package:cube_painter/model/crop_direction.dart';
import 'package:cube_painter/model/grid_point.dart';
import 'package:cube_painter/shared/grid_transform.dart';
import 'package:cube_painter/widgets/unit_cube.dart';
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
      : center = json['center'],
        crop = Crop.values[json['cropIndex']];

  Map<String, dynamic> toJson() => {'center': center, 'cropIndex': crop.index};
}
