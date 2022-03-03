import 'dart:convert';
import 'dart:math';

import 'package:cube_painter/out.dart';
import 'package:cube_painter/persisted/cube_info.dart';
import 'package:cube_painter/transform/position_to_unit.dart';
import 'package:flutter/material.dart';

const noWarn = out;

/// The main store of the entire model.
/// For loading and saving all the cube positions and their info
/// loaded from a json file.
class Painting {
  final List<CubeInfo> cubeInfos;

  const Painting({required this.cubeInfos});

  Painting.fromEmpty() : cubeInfos = <CubeInfo>[];

  Painting.fromString(String json) : this.fromJson(jsonDecode(json));

  UnitTransform get unitTransform => _calcUnitScaleAndOffset(cubeInfos);

  @override
  String toString() => jsonEncode(this);

  Painting.fromJson(Map<String, dynamic> json)
      : cubeInfos = _listFromJson(json).toList();

  Map<String, dynamic> toJson() => {'cubes': cubeInfos};

  static Iterable<CubeInfo> _listFromJson(Map<String, dynamic> json) sync* {
    for (final cubeInfoObject in json['cubes']) {
      yield CubeInfo.fromJson(cubeInfoObject);
    }
  }
}

class UnitTransform {
  final double scale;
  final Offset offset;

  const UnitTransform({required this.scale, required this.offset});
}

UnitTransform _calcUnitScaleAndOffset(List<CubeInfo> cubeInfos) {
  double minX = 9999999;
  double minY = 9999999;

  double maxX = -9999999;
  double maxY = -9999999;

  for (CubeInfo info in cubeInfos) {
    final offset = positionToUnitOffset(info.center);

    if (minX > offset.dx) {
      minX = offset.dx;
    }
    if (maxX < offset.dx) {
      maxX = offset.dx;
    }
    if (minY > offset.dy) {
      minY = offset.dy;
    }
    if (maxY < offset.dy) {
      maxY = offset.dy;
    }
  }

  final double rangeX = maxX - minX;
  final double rangeY = maxY - minY;
  // out('$minX,$maxX,$rangeX');
  // out('$minY,$maxY,$rangeY');

  // Add 1 to scale for half the size of cube each side of center.
  return UnitTransform(
    scale: 1 / (1 + max(rangeX, rangeY)),
    offset: -Offset(minX + maxX, minY + maxY) / 2,
  );
}
