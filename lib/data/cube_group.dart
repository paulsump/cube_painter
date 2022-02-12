import 'package:cube_painter/data/assets.dart';
import 'package:cube_painter/data/cube_info.dart';
import 'package:cube_painter/out.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const noWarn = out;

CubeGroupNotifier getCubeGroupNotifier(BuildContext context) {
  return Provider.of<CubeGroupNotifier>(context, listen: false);
}

CubeGroup getCubeGroup(BuildContext context) {
  return getCubeGroupNotifier(context).cubeGroup;
}

List<CubeInfo> getCubeInfos(BuildContext context) {
  return getCubeGroup(context).list;
}

/// The main store of the entire model.
/// For loading and saving all the cube positions and their info
/// loaded from a json file.
class CubeGroup {
  final List<CubeInfo> list;

  const CubeGroup(this.list);

  CubeGroup.fromJson(Map<String, dynamic> json)
      : list = _listFromJson(json).toList();

  @override
  String toString() => '$list';

  static Iterable<CubeInfo> _listFromJson(Map<String, dynamic> json) sync* {
    for (final cubeInfoObject in json['list']) {
      yield CubeInfo.fromJson(cubeInfoObject);
    }
  }

  Map<String, dynamic> toJson() => {'list': list};
}

/// access to the main store of the entire model
class CubeGroupNotifier extends ChangeNotifier {
  late CubeGroup _cubeGroup;

  final _filePaths = <String>[];
  int _currentIndex = 0;

  CubeGroup get cubeGroup => _cubeGroup;

  void init({
    required String folderPath,
    required VoidCallback whenComplete,
  }) async {
    final filePaths = await Assets.getFilePaths(folderPath);

    for (String filePath in filePaths) {
      _filePaths.add(filePath);
    }

    await _loadCubeGroup();
    whenComplete();
  }

  Future<void> _loadCubeGroup() async {
    final map = await Assets.loadJson(_filePaths[_currentIndex]);

    _cubeGroup = CubeGroup.fromJson(map);
  }

  void increment(int increment) {
    _currentIndex += increment;
    _currentIndex %= _filePaths.length;

    _loadCubeGroup();
  }
}
