import 'package:cube_painter/data/crop.dart';
import 'package:cube_painter/data/position.dart';
import 'package:flutter/material.dart';

class CubeInfo {
  final Position center;

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
      : center = Position.fromJson(json['center']),
        crop = Crop.values[json['cropIndex']];

  Map<String, dynamic> toJson() => {'center': center, 'cropIndex': crop.index};
}
