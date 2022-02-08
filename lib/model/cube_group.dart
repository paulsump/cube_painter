import 'dart:convert';

import 'package:cube_painter/model/cube_info.dart';

/// For loading and saving all the cube positions and their info
/// Loaded from a json file.
class CubeGroup {
  final List<CubeInfo> list;

  const CubeGroup(this.list);

  @override
  String toString() => '$list';

  /// for load
  CubeGroup.fromJson(String json) : list = _listFromJson(json).toList();

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
