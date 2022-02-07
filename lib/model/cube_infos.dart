import 'dart:convert';

import 'package:cube_painter/model/cube_info.dart';
import 'package:flutter/material.dart';

/// for passing around cube positions and their info
class CubeInfos {
  final List<CubeInfo> list;

  const CubeInfos(this.list);

  @override
  bool operator ==(Object other) =>
      other is CubeInfos ? list == other.list : false;

  @override
  int get hashCode => hashValues(list, 1);

  @override
  String toString() => '$list';

  /// for load
  CubeInfos.fromJson(String json) : list = _listFromJson(json).toList();

  /// for load
  static Iterable<CubeInfo> _listFromJson(String json) sync* {
    for (final cubeInfoObject in jsonDecode(json)) {
      yield CubeInfo.fromJson(cubeInfoObject);
    }
  }

  /// for save
  String toJson() => _jsonFromList(list);

  /// for save
  static String _jsonFromList(List<CubeInfo> cubes) {
    return jsonEncode(cubes);
  }
}
