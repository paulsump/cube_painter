import 'dart:convert';
import 'dart:io';

import 'package:cube_painter/data/assets.dart';
import 'package:cube_painter/data/cube_info.dart';
import 'package:cube_painter/data/persist.dart';
import 'package:cube_painter/out.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

const noWarn = out;

CubeGroupNotifier getCubeGroupNotifier(BuildContext context,
    {bool listen = false}) {
  return Provider.of<CubeGroupNotifier>(context, listen: listen);
}

/// The main store of the entire model.
/// For loading and saving all the cube positions and their info
/// loaded from a json file.
class CubeGroup {
  final List<CubeInfo> _cubeInfos;

  const CubeGroup(this._cubeInfos);

  List<CubeInfo> get cubeInfos => _cubeInfos;

  CubeGroup.fromJson(Map<String, dynamic> json)
      : _cubeInfos = _listFromJson(json).toList();

  @override
  String toString() => '$_cubeInfos';

  static Iterable<CubeInfo> _listFromJson(Map<String, dynamic> json) sync* {
    for (final cubeInfoObject in json['cubes']) {
      yield CubeInfo.fromJson(cubeInfoObject);
    }
  }

  Map<String, dynamic> toJson() => {'cubes': _cubeInfos};
}

/// access to the main store of the entire model
class CubeGroupNotifier extends ChangeNotifier {
  final _cubeGroups = <String, CubeGroup>{};

  bool get hasCubes => _cubeGroups.isNotEmpty && cubeGroup.cubeInfos.isNotEmpty;

  late String _currentFilePath;

  late VoidCallback _onSuccessfulLoad;

  CubeGroup get cubeGroup => _cubeGroups[_currentFilePath]!;

  void setCubeGroup(CubeGroup cubeGroup) {
    _cubeGroups[_currentFilePath] = cubeGroup;
  }

  Iterable<CubeGroup> get cubeGroups => _cubeGroups.values;

  void init({
    required VoidCallback onSuccessfulLoad,
  }) async {
    _onSuccessfulLoad = onSuccessfulLoad;

    await _loadAllCubeGroups();

    // TODO load previous run's file,
    _updateAfterLoad();
  }

  void _updateAfterLoad() {
    // TODO if fail, alert user, perhaps skip
    // TODO iff finally:
    _onSuccessfulLoad();
    // TODO clear undo (make undoer a notifier and notifyListeners for button enabled.
    notifyListeners();
  }

  String get json => jsonEncode(cubeGroup);

  void load({required String filePath}) {
    _currentFilePath = filePath;

    _updateAfterLoad();
  }

  void save() => saveString(filePath: _currentFilePath, string: json);

  void saveACopy() {
    //TODO Gen filename
    // fileName = millisecondsSinceEpoc
    //TODO Set currentFilePath = '$path/$fileName'
    // await saveString(filePath: currentFilePath, string:json);
  }

  void addCubeInfo(CubeInfo info) => cubeGroup.cubeInfos.add(info);

  void createPersisted() {
    //todo createPersisted
  }

  void clear() => cubeGroup.cubeInfos.clear();

  Future<void> _loadAllCubeGroups() async {
    const assetsFolder = 'samples';

    final Directory appFolder = await getApplicationDocumentsDirectory();
    // TODO do we want to do this every time, or just the first time?
    await Assets.copyAllFromTo(assetsFolder, appFolder.path);

    List<String> paths = await getAllAppFilePaths(appFolder);

    // display in reverse chronological order (most recent first)
    // this is because the file name is a number that increases with time.
    paths.sort((a, b) => b.compareTo(a));

    //  Most recent
    _currentFilePath = paths[0];

    for (final String path in paths) {
      final File file = File(path);

      String json = await file.readAsString();
      final map = jsonDecode(json);

      _cubeGroups[path] = CubeGroup.fromJson(await map);
    }
  }

  Future<List<String>> getAllAppFilePaths(Directory appFolder) async {
    final paths = <String>[];

    await for (final FileSystemEntity fileSystemEntity in appFolder.list()) {
      final String path = fileSystemEntity.path;

      if (path.endsWith('.json')) {
        paths.add(path);
      }
    }
    return paths;
  }
}
