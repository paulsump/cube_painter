import 'package:cube_painter/data/cube_info.dart';

/// For loading and saving all the cube positions and their info
/// Loaded from a json file.
class CubeGroup {
  final List<CubeInfo> list;

  const CubeGroup(this.list);

  @override
  String toString() => '$list';

  CubeGroup.fromJson(Map<String, dynamic> json)
      : list = _listFromJson(json).toList();

  static Iterable<CubeInfo> _listFromJson(Map<String, dynamic> json) sync* {
    for (final cubeInfoObject in json['list']) {
      yield CubeInfo.fromJson(cubeInfoObject);
    }
  }

  Map<String, dynamic> toJson() => {'list': list};
}

