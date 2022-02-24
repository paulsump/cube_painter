import 'dart:collection';
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

  Map<String, dynamic> toJson() => {'cubes': _cubeInfos};

  CubeGroup.fromJsonString(String json) : this.fromJson(jsonDecode(json));

  String get jsonString => jsonEncode(this);

  @override
  String toString() => '$_cubeInfos';

  static Iterable<CubeInfo> _listFromJson(Map<String, dynamic> json) sync* {
    for (final cubeInfoObject in json['cubes']) {
      yield CubeInfo.fromJson(cubeInfoObject);
    }
  }
}

/// access to the main store of the entire model
class CubeGroupNotifier extends ChangeNotifier {
  final _cubeGroups = <String, CubeGroup>{};

  late Settings _settings;

  late VoidCallback _onSuccessfulLoad;

  String _savedJson = '';

  bool get modified => json != _savedJson;

  bool get hasCubes =>
      _cubeGroups.isNotEmpty &&
      _hasCubeGroupForCurrentFilePath &&
      cubeGroup.cubeInfos.isNotEmpty;

  bool get _hasCubeGroupForCurrentFilePath {
    if (!_cubeGroups.containsKey(currentFilePath)) {
      out(currentFilePath);

      assert(false,
          "_cubeGroups doesn't contain key of currentFilePath: $currentFilePath");
      return false;
    }
    return true;
  }

  String get currentFilePath => _settings.currentFilePath;

  void saveCurrentFilePath(String filePath) {
    _settings.currentFilePath = filePath;

    //TODO save settings toJson
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

  UnmodifiableListView<MapEntry> get cubeGroupEntries =>
      UnmodifiableListView<MapEntry>(_cubeGroups.entries.toList());

  // Iterable<MapEntry> get cubeGroupEntries => _cubeGroups.entries;
// get forE=>_cubeGroups.forEach;
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

    _savedJson = json;

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

  String get json => cubeGroup.jsonString;

  void loadFile({required String filePath}) {
    saveCurrentFilePath(filePath);

    _savedJson = json;
    _updateAfterLoad();
  }

  Future<void> saveFile() async {
    await saveString(filePath: currentFilePath, string: json);
    _savedJson = json;
  }

  Future<void> saveACopyFile() async {
    final jsonCopy = json;

    await setNewFilePath();
    pushCubeGroup(CubeGroup.fromJsonString(jsonCopy));

    _savedJson = json;
    saveFile();
  }

  void setJson(String json) => setCubeGroup(CubeGroup.fromJsonString(json));

  void addCubeInfo(CubeInfo info) => cubeGroup.cubeInfos.add(info);

  Future<void> setNewFilePath() async {
    final Directory appFolder = await getApplicationDocumentsDirectory();
    final String appFolderPath = '${appFolder.path}${Platform.pathSeparator}';

    final int uniqueId = DateTime.now().millisecondsSinceEpoch;
    saveCurrentFilePath('$appFolderPath$uniqueId$userCubesExtension');
  }

  Future<void> newFile() async {
    await setNewFilePath();

    pushCubeGroup(CubeGroup.empty());
    _savedJson = json;

    _updateAfterLoad();
  }

  // insert at the top of the list
  void pushCubeGroup(CubeGroup cubeGroup) {
    final copy = Map<String, CubeGroup>.from(_cubeGroups);

    _cubeGroups.clear();
    setCubeGroup(cubeGroup);

    _cubeGroups.addAll(copy);
  }

  Future<void> deleteFile({required String filePath}) async {
    _cubeGroups.remove(filePath);

    final File file = File(filePath);
    file.delete();

    if (currentFilePath == filePath) {
      if (_cubeGroups.isEmpty) {
        newFile();
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

        _cubeGroups[path] = CubeGroup.fromJsonString(await file.readAsString());
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
