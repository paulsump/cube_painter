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

const cubesExtension = '.cubes.json';

/// The main store of the entire model.
/// For loading and saving all the cube positions and their info
/// loaded from a json file.
class CubeGroup {
  final List<CubeInfo> _cubeInfos;

  const CubeGroup(this._cubeInfos);

  CubeGroup.empty() : _cubeInfos = <CubeInfo>[];

  List<CubeInfo> get cubeInfos => _cubeInfos;

  CubeGroup.fromString(String json) : this.fromJson(jsonDecode(json));

  @override
  String toString() => jsonEncode(this);

  CubeGroup.fromJson(Map<String, dynamic> json)
      : _cubeInfos = _listFromJson(json).toList();

  Map<String, dynamic> toJson() => {'cubes': _cubeInfos};

  static Iterable<CubeInfo> _listFromJson(Map<String, dynamic> json) sync* {
    for (final cubeInfoObject in json['cubes']) {
      yield CubeInfo.fromJson(cubeInfoObject);
    }
  }
}

/// access to the main store of the entire model
class CubeGroupNotifier extends ChangeNotifier {
  final _cubeGroups = <String, CubeGroup>{};

  late String settingsPath;
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

      return false;
    }
    return true;
  }

  String get currentFilePath => _settings.currentFilePath;

  void saveCurrentFilePath(String filePath) {
    _settings.currentFilePath = filePath;

    saveSettings();
  }

  CubeGroup get cubeGroup {
    if (!_hasCubeGroupForCurrentFilePath) {
      assert(false,
          "_cubeGroups doesn't contain key of currentFilePath: $currentFilePath");

      // prevent irreversible crash for now, for debugging purposes.
      return CubeGroup.empty();
    }
    return _cubeGroups[currentFilePath]!;
  }

  void setCubeGroup(CubeGroup cubeGroup) =>
      _cubeGroups[currentFilePath] = cubeGroup;

  UnmodifiableListView<MapEntry> get cubeGroupEntries =>
      UnmodifiableListView<MapEntry>(_cubeGroups.entries.toList());

  void init({required VoidCallback onSuccessfulLoad}) async {
    _onSuccessfulLoad = onSuccessfulLoad;

    settingsPath = await getSettingsPath();

    // if(true){
    if (!await File(settingsPath).exists()) {
      _settings = Settings.fromJson({
        'currentFilePath': '',
        'copiedSamples': false,
      });
    } else {
      _settings = Settings.fromString(await loadString(filePath: settingsPath));
    }

    if (!_settings.copiedSamples) {
      await copySamples();

      _settings.copiedSamples = true;
      await saveSettings();
    }

    final firstPath = await _loadAllCubeGroups();

    if (currentFilePath.isEmpty) {
      //  Most recently created is now first in list
      saveCurrentFilePath(firstPath);
    }

    if (!_cubeGroups.containsKey(currentFilePath)) {
      out("currentFilePath not found ('$currentFilePath'), so using the first in the list");

      saveCurrentFilePath(firstPath);
    }

    _savedJson = json;
    _updateAfterLoad();
  }

  void _updateAfterLoad() {
    // TODO if fail, alert user, perhaps skip
    // TODO iff finally:
    if (_cubeGroups.isNotEmpty) {
      _onSuccessfulLoad();

      notifyListeners();
    }
  }

  String get json => cubeGroup.toString();

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
    pushCubeGroup(CubeGroup.fromString(jsonCopy));

    _savedJson = json;
    saveFile();
  }

  void setJson(String json) => setCubeGroup(CubeGroup.fromString(json));

  void addCubeInfo(CubeInfo info) => cubeGroup.cubeInfos.add(info);

  Future<void> setNewFilePath() async {
    final String appFolderPath = await getAppFolderPath();

    final int uniqueId =
        (DateTime.now().millisecondsSinceEpoch - 1645648060000) ~/ 100;

    saveCurrentFilePath('$appFolderPath$uniqueId$cubesExtension');
  }

  Future<String> getAppFolderPath() async {
    final Directory appFolder = await getApplicationDocumentsDirectory();

    return '${appFolder.path}${Platform.pathSeparator}';
  }

  Future<void> newFile() async {
    await setNewFilePath();

    pushCubeGroup(CubeGroup.empty());
    _savedJson = json;

    _updateAfterLoad();
    saveFile();
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

    //we might never have saved a new filename, so check existence
    if (await file.exists()) {
      file.delete();
    }

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

  Future<String> _loadAllCubeGroups({bool ignoreCurrent = false}) async {
    final Directory appFolder = await getApplicationDocumentsDirectory();

    List<String> paths = await getAllAppFilePaths(appFolder);

    // display in reverse chronological order (most recent first)
    // this is because the file name is a number that increases with time.
    paths.sort((a, b) => b.compareTo(a));

    for (final String path in paths) {
      if (!(ignoreCurrent && path == currentFilePath)) {
        final File file = File(path);

        _cubeGroups[path] = CubeGroup.fromString(await file.readAsString());
      }
    }

    return paths.first;
  }

  Future<List<String>> getAllAppFilePaths(Directory appFolder) async {
    final paths = <String>[];

    await for (final FileSystemEntity fileSystemEntity in appFolder.list()) {
      final String path = fileSystemEntity.path;

      if (path.endsWith(cubesExtension)) {
        paths.add(path);
      }
    }
    return paths;
  }

  Future<String> getSettingsPath() async {
    final String appFolderPath = await getAppFolderPath();

    return '$appFolderPath${Settings.fileName}';
  }

  Future<void> saveSettings() async =>
      saveString(filePath: settingsPath, string: _settings.toString());

  Future<void> copySamples() async {
    const assetsFolder = 'samples';

    final String appFolderPath = await getAppFolderPath();

    await Assets.copyAllFromTo(assetsFolder, appFolderPath,
        extensionReplacement: cubesExtension);
  }
}
