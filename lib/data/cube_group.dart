import 'dart:collection';
import 'dart:convert';

import 'package:cube_painter/data/assets.dart';
import 'package:cube_painter/data/cube_info.dart';
import 'package:cube_painter/out.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const noWarn = out;

CubeGroupNotifier getCubeGroupNotifier(BuildContext context) {
  return Provider.of<CubeGroupNotifier>(context, listen: false);
}

CubeGroup _getCubeGroup(BuildContext context) {
  return getCubeGroupNotifier(context).cubeGroup;
}

UnmodifiableListView<CubeInfo> getCubeInfos(BuildContext context) {
  return UnmodifiableListView(_getCubeGroup(context).cubes);
}

/// The main store of the entire model.
/// For loading and saving all the cube positions and their info
/// loaded from a json file.
class CubeGroup {
  final List<CubeInfo> cubes;

  const CubeGroup(this.cubes);

  CubeGroup.fromJson(Map<String, dynamic> json)
      : cubes = _listFromJson(json).toList();

  @override
  String toString() => '$cubes';

  static Iterable<CubeInfo> _listFromJson(Map<String, dynamic> json) sync* {
    for (final cubeInfoObject
        in json[json.containsKey('cubes') ? 'cubes' : 'list']) {
      yield CubeInfo.fromJson(cubeInfoObject);
    }
  }

  Map<String, dynamic> toJson() => {'cubes': cubes};
}

/// access to the main store of the entire model
class CubeGroupNotifier extends ChangeNotifier {
  late CubeGroup _cubeGroup;

  late VoidCallback _addCubes;
  final _filePaths = <String>[];

  int _currentIndex = 0;

  CubeGroup get cubeGroup => _cubeGroup;

  set cubeGroup(value) => _cubeGroup = value;

  void init({
    required String folderPath,
    required VoidCallback addCubes,
  }) async {
    final filePaths = await Assets.getFilePaths(folderPath);

    for (String filePath in filePaths) {
      _filePaths.add(filePath);
    }

    assert(_filePaths.isNotEmpty);

    _addCubes = addCubes;
    await _loadCubeGroup();
  }

  Future<void> _loadCubeGroup() async {
    final map = await Assets.loadJson(_filePaths[_currentIndex]);

    _cubeGroup = CubeGroup.fromJson(map);
    // TODO if fail, alert user, perhaps skip
    // TODO iff finally:
    _addCubes();
    // TODO clear undo (make undoer a notifier and notifyListeners for button enabled.
  }

  String get json => jsonEncode(cubeGroup);

  void increment(int increment) {
    _currentIndex += increment;
    _currentIndex %= _filePaths.length;

    _loadCubeGroup();
  }
}
