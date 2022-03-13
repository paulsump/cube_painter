// Copyright (c) 2022, Paul Sumpner.  All rights reserved.

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
  const Painting({required this.cubeInfos});

  final List<CubeInfo> cubeInfos;

  Painting.fromEmpty() : cubeInfos = <CubeInfo>[];

  Painting.fromString(String json) : this.fromJson(jsonDecode(json));

  UnitTransform get unitTransform => UnitTransform(cubeInfos);

  @override
  String toString() => jsonEncode(this);

  Painting.fromJson(Map<String, dynamic> json)
      : cubeInfos = json['cubes']
            .map<CubeInfo>(
                (cubeInfoObject) => CubeInfo.fromJson(cubeInfoObject))
            .toList();

  Map<String, dynamic> toJson() => {'cubes': cubeInfos};
}

/// Used to scale the [Painting] down to unit size.
///
/// Based on the bounding rectangle of the [Painting]s positions
class UnitTransform {
  UnitTransform(List<CubeInfo> cubeInfos) {
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

    // Add 1 to scale for half the size of cube each side of center.
    scale = cubeInfos.length == 1 ? 0.6 : 1 / (1 + max(rangeX, rangeY));
    offset = -Offset(minX + maxX, minY + maxY) / 2;
  }

  late double scale;
  late Offset offset;

  @override
  String toString() => '$scale, $offset';
}
