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

SketchBank getSketchBank(BuildContext context, {bool listen = false}) =>
    Provider.of<SketchBank>(context, listen: listen);

const cubesExtension = '.cubes.json';

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

/// access to the main store of the entire model
/// TODO Rename to StaticSketchBank if i've got an AnimSketchBank
/// TODO Rename to ShapeBank
class SketchBank extends ChangeNotifier {
  // TODO RENAME TO _sketchMap
  final _sketchs = <String, Sketch>{};

  late String settingsPath;
  late Settings _settings;

  late VoidCallback _onSuccessfulLoad;

  String _savedJson = '';

  bool get modified => json != _savedJson;

  bool get hasCubes =>
      _sketchs.isNotEmpty &&
      _hasSketchForCurrentFilePath &&
      sketch.cubeInfos.isNotEmpty;

  bool get _hasSketchForCurrentFilePath {
    if (!_sketchs.containsKey(currentFilePath)) {
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

  Sketch get sketch {
    if (!_hasSketchForCurrentFilePath) {
      assert(false,
          "_sketchs doesn't contain key of currentFilePath: $currentFilePath");

      // prevent irreversible crash for now, for debugging purposes.
      return Sketch.empty();
    }
    return _sketchs[currentFilePath]!;
  }

  void setSketch(Sketch sketch) => _sketchs[currentFilePath] = sketch;

  UnmodifiableListView<MapEntry> get sketchEntries =>
      UnmodifiableListView<MapEntry>(_sketchs.entries.toList());

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

    final firstPath = await _loadAllSketchs();

    if (currentFilePath.isEmpty) {
      //  Most recently created is now first in list
      saveCurrentFilePath(firstPath);
    }

    if (!_sketchs.containsKey(currentFilePath)) {
      out("currentFilePath not found ('$currentFilePath'), so using the first in the list");

      saveCurrentFilePath(firstPath);
    }

    _savedJson = json;
    _updateAfterLoad();
  }

  void _updateAfterLoad() {
    // TODO if fail, alert user, perhaps skip
    // TODO iff finally:
    if (_sketchs.isNotEmpty) {
      _onSuccessfulLoad();

      notifyListeners();
    }
  }

  String get json => sketch.toString();

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
    pushSketch(Sketch.fromString(jsonCopy));

    _savedJson = json;
    saveFile();
  }

  void setJson(String json) => setSketch(Sketch.fromString(json));

  void addCubeInfo(CubeInfo info) => sketch.cubeInfos.add(info);

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

    pushSketch(Sketch.empty());
    _savedJson = json;

    _updateAfterLoad();
    saveFile();
  }

  // insert at the top of the list
  void pushSketch(Sketch sketch) {
    final copy = Map<String, Sketch>.from(_sketchs);

    _sketchs.clear();
    setSketch(sketch);

    _sketchs.addAll(copy);
  }

  Future<void> deleteFile({required String filePath}) async {
    _sketchs.remove(filePath);

    final File file = File(filePath);

    //we might never have saved a new filename, so check existence
    if (await file.exists()) {
      file.delete();
    }

    if (currentFilePath == filePath) {
      if (_sketchs.isEmpty) {
        newFile();
      } else {
        loadFile(filePath: _sketchs.keys.first);
      }
    }

    notifyListeners();
  }

  void clear() => sketch.cubeInfos.clear();

  Future<String> _loadAllSketchs({bool ignoreCurrent = false}) async {
    final Directory appFolder = await getApplicationDocumentsDirectory();

    List<String> paths = await getAllAppFilePaths(appFolder);

    // display in reverse chronological order (most recent first)
    // this is because the file name is a number that increases with time.
    paths.sort((a, b) => b.compareTo(a));

    for (final String path in paths) {
      if (!(ignoreCurrent && path == currentFilePath)) {
        final File file = File(path);

        _sketchs[path] = Sketch.fromString(await file.readAsString());
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
