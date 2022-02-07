import 'dart:convert';

import 'package:cube_painter/model/cube_info.dart';

/// TODO USE As the main model?
/// it might end up being the place for storing the positions
/// either way it with be used
/// for loading and saving all the cube positions and their info
class CubeInfos {
  final List<CubeInfo> list;

  const CubeInfos(this.list);

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
