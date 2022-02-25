import 'package:cube_painter/data/position.dart';
import 'package:cube_painter/data/slice.dart';
import 'package:flutter/material.dart';

class CubeInfo {
  final Position center;

  final Slice slice;

  const CubeInfo({required this.center, required this.slice});

  @override
  bool operator ==(Object other) => other is CubeInfo
      ? center == other.center && slice == other.slice
      : false;

  @override
  int get hashCode => hashValues(center, slice);

  @override
  String toString() => '$center,$slice';

  CubeInfo.fromJson(Map<String, dynamic> json)
      : center = Position.fromJson(json['center']),
        slice = json.containsKey('sliceIndex')
            ? Slice.values[json['sliceIndex']]
            : Slice.c;

  Map<String, dynamic> toJson() => Slice.c == slice
      ? {'center': center}
      : {'center': center, 'sliceIndex': slice.index};
}
