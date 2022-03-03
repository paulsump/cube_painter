import 'package:cube_painter/persisted/position.dart';
import 'package:cube_painter/persisted/slice.dart';
import 'package:flutter/material.dart';

/// The position and type of a cube.
/// This is the basic building block for the persisted [Painting]
/// Persisted to json.
/// For convenience you can get the json as a string via toString()
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
        slice = json.containsKey('slice')
            ? Slice.values.byName(json['slice'])
            : Slice.whole;

  Map<String, dynamic> toJson() => Slice.whole == slice
      ? {'center': center}
      : {'center': center, 'slice': getSliceName(slice)};
}
