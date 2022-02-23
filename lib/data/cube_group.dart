import 'dart:convert';
import 'dart:io';

import 'package:cube_painter/data/assets.dart';
import 'package:cube_painter/data/cube_info.dart';
import 'package:cube_painter/data/persist.dart';
import 'package:cube_painter/data/settings.dart';
import 'package:cube_painter/out.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

const noWarn = out;

CubeGroupNotifier getCubeGroupNotifier(BuildContext context,
    {bool listen = false}) {
  return Provider.of<CubeGroupNotifier>(context, listen: listen);
}

const sampleCubesExtension = '.sampleCubes.json';
const userCubesExtension = '.userCubes.json';

/// The main store of the entire model.
/// For loading and saving all the cube positions and their info
/// loaded from a json file.
class CubeGroup {
  final List<CubeInfo> _cubeInfos;

  const CubeGroup(this._cubeInfos);
  CubeGroup.empty() : _cubeInfos = <CubeInfo>[];

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

  late Settings _settings;

  late VoidCallback _onSuccessfulLoad;

  String savedJson = '';

  bool get modified => json != savedJson;

  bool get hasCubes =>
      _cubeGroups.isNotEmpty &&
      _hasCubeGroupForCurrentFilePath &&
      cubeGroup.cubeInfos.isNotEmpty;

  bool get _hasCubeGroupForCurrentFilePath {
    if (!_cubeGroups.containsKey(currentFilePath)) {
      out(currentFilePath);
      out(_cubeGroups.keys);

      assert(false,
          "_cubeGroups doesn't contain key of currentFilePath: $currentFilePath");
      return false;
    }
    return true;
  }

  String get currentFilePath => _settings.currentFilePath;

  void saveCurrentFilePath(String filePath) {
    _settings.currentFilePath = filePath;

    //TODO SAVE SETTINGS toJson
  }

  CubeGroup get cubeGroup {
    if (!_hasCubeGroupForCurrentFilePath) {
      // PREvent irreversible crash for debugging purposes now
      return CubeGroup.empty();
    }
    return _cubeGroups[currentFilePath]!;
  }

  void setCubeGroup(CubeGroup cubeGroup) =>
      _cubeGroups[currentFilePath] = cubeGroup;

  Iterable<MapEntry> get cubeGroupEntries => _cubeGroups.entries;

  // TODO REMOVE?
  bool get canSave => modified && currentFilePath.endsWith(userCubesExtension);

  void init({required VoidCallback onSuccessfulLoad}) async {
    _onSuccessfulLoad = onSuccessfulLoad;

    // TODO load fromJson
    _settings = Settings.fromJson({
      'currentFilePath': '',
      'showCrops': true,
    });

    // TODO do we want to do this every time, or just the first time?
    await copySamples();

    await _loadAllCubeGroups();

    savedJson = json;

    // TODO load previous run's file, by saving settings
    _updateAfterLoad();
  }

  void _updateAfterLoad() {
    // TODO if fail, alert user, perhaps skip
    // TODO iff finally:
    if (_cubeGroups.isNotEmpty) {
      _onSuccessfulLoad();
      // TODO clear undo (make undoer a notifier and notifyListeners for button enabled.
      notifyListeners();
    }
  }

  String get json => jsonEncode(cubeGroup);

  void loadFile({required String filePath}) {
    // if (_saved(context)) {
    saveCurrentFilePath(filePath);
    savedJson = json;

    _updateAfterLoad();
    // }
  }

  void saveFile() async {
    await saveString(filePath: currentFilePath, string: json);
    savedJson = json;
  }

  void saveACopyFile() async {
    final jsonCopy = json;

    await setNewFilePath();
    setJson(jsonCopy);

    savedJson = json;
    saveFile();
  }

  void setJson(String json) {
    final Map<String, dynamic> map = jsonDecode(json);

    setCubeGroup(CubeGroup.fromJson(map));
  }

  void addCubeInfo(CubeInfo info) => cubeGroup.cubeInfos.add(info);

  Future<void> setNewFilePath() async {
    final Directory appFolder = await getApplicationDocumentsDirectory();
    final String appFolderPath = '${appFolder.path}${Platform.pathSeparator}';

    final int uniqueId = DateTime.now().millisecondsSinceEpoch;
    saveCurrentFilePath('$appFolderPath$uniqueId$userCubesExtension');
  }

  Future<void> createNewFile() async {
    await setNewFilePath();

    final copy = Map<String, CubeGroup>.from(_cubeGroups);
    _cubeGroups.clear();

    // insert the new one at the top
    setCubeGroup(CubeGroup.empty());
    savedJson = json;

    _cubeGroups.addAll(copy);
    _updateAfterLoad();
  }

  Future<void> deleteFile({required String filePath}) async {
    _cubeGroups.remove(filePath);

    final File file = File(filePath);
    file.delete();

    if (currentFilePath == filePath) {
      if (_cubeGroups.isEmpty) {
        createNewFile();
      } else {
        loadFile(filePath: _cubeGroups.keys.first);
      }
    }

    notifyListeners();
  }

  void clear() => cubeGroup.cubeInfos.clear();

  Future<void> _loadAllCubeGroups({bool ignoreCurrent = false}) async {
    final Directory appFolder = await getApplicationDocumentsDirectory();

    List<String> paths = await getAllAppFilePaths(appFolder);

    // display in reverse chronological order (most recent first)
    // this is because the file name is a number that increases with time.
    paths.sort((a, b) => b.compareTo(a));

    if (currentFilePath.isEmpty) {
      //  Most recently created is now first in list
      saveCurrentFilePath(paths[0]);
    }

    for (final String path in paths) {
      if (!(ignoreCurrent && path == currentFilePath)) {
        final File file = File(path);

        final map = jsonDecode(await file.readAsString());
        _cubeGroups[path] = CubeGroup.fromJson(await map);
      }
    }
  }

  Future<List<String>> getAllAppFilePaths(Directory appFolder) async {
    final paths = <String>[];

    await for (final FileSystemEntity fileSystemEntity in appFolder.list()) {
      final String path = fileSystemEntity.path;

      if (path.endsWith(userCubesExtension) ||
          path.endsWith(sampleCubesExtension)) {
        paths.add(path);
      }
    }
    return paths;
  }

  void loadSamples() async {
    copySamples();
    _loadAllCubeGroups(ignoreCurrent: true);
  }

  Future<void> copySamples() async {
    const assetsFolder = 'samples';

    final Directory appFolder = await getApplicationDocumentsDirectory();

    await Assets.copyAllFromTo(assetsFolder, appFolder.path,
        extensionReplacement: sampleCubesExtension);
  }

}
