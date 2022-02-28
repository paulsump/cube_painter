import 'dart:convert';

import 'package:cube_painter/out.dart';
import 'package:cube_painter/persisted/cube_info.dart';

const noWarn = out;

/// The main store of the entire model.
/// For loading and saving all the cube positions and their info
/// loaded from a json file.
class Sketch {
  final List<CubeInfo> _cubeInfos;

  const Sketch(this._cubeInfos);

  Sketch.empty() : _cubeInfos = <CubeInfo>[];

  Sketch.fromString(String json) : this.fromJson(jsonDecode(json));

  List<CubeInfo> get cubeInfos => _cubeInfos;

  @override
  String toString() => jsonEncode(this);

  Sketch.fromJson(Map<String, dynamic> json)
      : _cubeInfos = _listFromJson(json).toList();

  Map<String, dynamic> toJson() => {'cubes': _cubeInfos};

  static Iterable<CubeInfo> _listFromJson(Map<String, dynamic> json) sync* {
    for (final cubeInfoObject in json['cubes']) {
      yield CubeInfo.fromJson(cubeInfoObject);
    }
  }
}
