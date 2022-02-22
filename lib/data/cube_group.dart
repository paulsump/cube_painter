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
  final _cubeGroups = <CubeGroup>[];

  bool get hasCubes => _cubeGroups.isNotEmpty && cubeGroup.cubeInfos.isNotEmpty;

  late String currentFilePath;

  late VoidCallback _onSuccessfulLoad;

  final int _currentIndex = 0;

  CubeGroup get cubeGroup => _cubeGroups[_currentIndex];

  set cubeGroup(value) => _cubeGroups[_currentIndex] = value;

  List<CubeGroup> get cubeGroups => _cubeGroups;

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
    currentFilePath = filePath;

    //TODO MAP
    // cubeGroup = _cubeGroups[currentFilePath];
    _updateAfterLoad();
  }

  void save() => saveString(filePath: currentFilePath, string: json);

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
    await Assets.copyAllFromTo(assetsFolder, appFolder.path);

    await for (final FileSystemEntity f in appFolder.list()) {
      if (f.path.endsWith('.json')) {
        File file = File(f.path);

        // TODO Most recent
        currentFilePath = f.path;

        String json = await file.readAsString();
        final map = jsonDecode(json);

        _cubeGroups.add(CubeGroup.fromJson(await map));
      }
    }
  }
}
