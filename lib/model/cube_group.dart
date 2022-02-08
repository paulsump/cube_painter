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
  CubeGroup.fromJson(Map<String, dynamic> json)
      // : list = List.generate(
      //     json['list'].length,
      //     (i) => CubeInfo.fromJson(json['list'][i]),
      //   );
      : list = _listFromJson(json).toList();

  /// for load
  static Iterable<CubeInfo> _listFromJson(Map<String, dynamic> json) sync* {
    for (final cubeInfoObject in json['list']) {
      yield CubeInfo.fromJson(cubeInfoObject);
    }
  }

  // static Iterable<CubeInfo> _listFromJson(String json) sync* {
  //   for (final cubeInfoObject in jsonDecode(json)) {
  //     yield CubeInfo.fromJson(cubeInfoObject);
  //   }
  // }

  /// for save
  Map<String, dynamic> toJson() => {'list': list};

  /// for save
  static String _jsonFromList(List<CubeInfo> cubes) {
    return jsonEncode(cubes);
  }
}
