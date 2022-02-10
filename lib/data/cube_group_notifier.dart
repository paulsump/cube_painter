import 'package:cube_painter/data/assets.dart';
import 'package:cube_painter/data/cube_group.dart';
import 'package:cube_painter/data/cube_info.dart';
import 'package:cube_painter/out.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const noWarn = out;

List<CubeInfo> getCubeInfos(BuildContext context) {
  final cubeGroupNotifier =
      Provider.of<CubeGroupNotifier>(context, listen: false);

  return cubeGroupNotifier.cubeGroup.list;
}

/// the main store of the entire model
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
