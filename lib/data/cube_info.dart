import 'package:cube_painter/data/position.dart';
import 'package:cube_painter/data/slice.dart';
import 'package:flutter/material.dart';

class CubeInfo {
  final Position center;

  final Slice crop;

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
        crop = json.containsKey('sliceIndex')
            ? Slice.values[json['sliceIndex']]
            : Slice.c;

  Map<String, dynamic> toJson() => Slice.c == crop
      ? {'center': center}
      : {'center': center, 'sliceIndex': crop.index};
}
