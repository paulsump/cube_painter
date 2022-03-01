import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:cube_painter/out.dart';
import 'package:cube_painter/persisted/assets.dart';
import 'package:cube_painter/persisted/cube_info.dart';
import 'package:cube_painter/persisted/persist.dart';
import 'package:cube_painter/persisted/settings.dart';
import 'package:cube_painter/persisted/sketch.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

const noWarn = out;

SketchBank getSketchBank(BuildContext context, {bool listen = false}) =>
    Provider.of<SketchBank>(context, listen: listen);

const cubesExtension = '.cubes.json';

/// access to the main store of the entire model
/// For loading and saving all the cube positions and their info
/// loaded from a json file.
/// TODO Rename to StaticSketchBank if i've got an AnimSketchBank
class SketchBank extends ChangeNotifier {
  final _sketches = <String, Sketch>{};

  final example = SlicesExample();

  String get json => sketch.toString();

  final animCubeInfos = <CubeInfo>[];

  void addAllAnimCubeInfosToStaticCubeInfos() {
    sketch.cubeInfos.addAll(animCubeInfos);

    animCubeInfos.clear();
    notifyListeners();
  }

  //TODO FIx this copied comment
  /// once the brush has finished, it
  /// yields ownership of it's cubes to this parent widget.
  /// which then creates a similar list
  /// If we are in add gestureMode
  /// the cubes will end up going
  /// in the sketch once they've animated to full size.
  /// if we're in erase gestureMode they shrink to zero.
  /// either way they get removed from the animCubeInfos array once the
  /// anim is done.

  void addAllToAnimCubeInfos(List<CubeInfo> orphans) {
    animCubeInfos.addAll(orphans);
    setPlaying(true);
  }

  void setPingPong(bool value) {
    setPlaying(true);
    pingPong = value;
  }

  bool pingPong = false;

  late String settingsPath;
  late Settings _settings;

  late VoidCallback _onSuccessfulLoad;

  String _savedJson = '';

  bool _playing = false;

  bool get playing => _playing;

  void setPlaying(bool playing) {
    _playing = playing;
    // out(playing);
    notifyListeners();
  }

  bool get modified => json != _savedJson;

  bool get hasCubes =>
      _sketches.isNotEmpty &&
      _hasSketchForCurrentFilePath &&
      sketch.cubeInfos.isNotEmpty;

  bool get _hasSketchForCurrentFilePath {
    if (!_sketches.containsKey(currentFilePath)) {
      out(currentFilePath);

      return false;
    }
    return true;
  }

  String get currentFilePath => _settings.currentFilePath;

  void saveCurrentFilePath(String filePath) {
    _settings.currentFilePath = filePath;

    setPlaying(true);

    unawaited(saveSettings());
  }

  Sketch get sketch {
    if (!_hasSketchForCurrentFilePath) {
      assert(false,
          "_sketches doesn't contain key of currentFilePath: $currentFilePath");

      // prevent irreversible crash for now, for debugging purposes.
      return Sketch.empty();
    }
    return _sketches[currentFilePath]!;
  }

  void setSketch(Sketch sketch) => _sketches[currentFilePath] = sketch;

  UnmodifiableListView<MapEntry> get sketchEntries =>
      UnmodifiableListView<MapEntry>(_sketches.entries.toList());

  Future<void> init({required VoidCallback onSuccessfulLoad}) async {
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

    final firstPath = await _loadAllSketches();

    if (currentFilePath.isEmpty) {
      //  Most recently created is now first in list
      saveCurrentFilePath(firstPath);
    }

    if (!_sketches.containsKey(currentFilePath)) {
      out("currentFilePath not found ('$currentFilePath'), so using the first in the list");

      saveCurrentFilePath(firstPath);
    }

    _savedJson = json;
    _updateAfterLoad();

    unawaited(example.init());
  }

  void _updateAfterLoad() {
    // TODO if fail, alert user, perhaps skip
    // TODO iff finally:
    if (_sketches.isNotEmpty) {
      _onSuccessfulLoad();

      notifyListeners();
    }
  }

  // insert at the top of the list
  void pushSketch(Sketch sketch) {
    final copy = Map<String, Sketch>.from(_sketches);

    _sketches.clear();
    setSketch(sketch);

    _sketches.addAll(copy);
  }

  Future<void> newFile() async {
    addAllAnimCubeInfosToStaticCubeInfos();

    await _setNewFilePath();

    pushSketch(Sketch.empty());
    _savedJson = json;

    _updateAfterLoad();
    unawaited(saveFile());
  }

  void loadFile({required String filePath}) {

    saveCurrentFilePath(filePath);

    _savedJson = json;
    _updateAfterLoad();
  }

  Future<void> saveFile() async {
    addAllAnimCubeInfosToStaticCubeInfos();

    await saveString(filePath: currentFilePath, string: json);
    _savedJson = json;
  }

  Future<void> saveACopyFile() async {
    addAllAnimCubeInfosToStaticCubeInfos();

    final jsonCopy = json;

    await _setNewFilePath();
    pushSketch(Sketch.fromString(jsonCopy));

    _savedJson = json;
    unawaited(saveFile());
  }

  /// Creates a sketch from a json string
  /// called from [UndoNotifier]
  void setJson(String json) {
    setSketch(Sketch.fromString(json));

    notifyListeners();
  }

  void addCubeInfo(CubeInfo info) => sketch.cubeInfos.add(info);

  Future<void> _setNewFilePath() async {
    final String appFolderPath = await _getAppFolderPath();

    final int uniqueId =
        (DateTime.now().millisecondsSinceEpoch - 1645648060000) ~/ 100;

    saveCurrentFilePath('$appFolderPath$uniqueId$cubesExtension');
  }

  Future<String> _getAppFolderPath() async {
    final Directory appFolder = await getApplicationDocumentsDirectory();

    return '${appFolder.path}${Platform.pathSeparator}';
  }

  Future<void> resetCurrentSketch() async =>
      _sketches[currentFilePath] = Sketch.fromString(_savedJson);

  Future<void> deleteCurrentFile() async {
    _sketches.remove(currentFilePath);

    final File file = File(currentFilePath);

    // we might never have saved a new filename, so check existence
    if (await file.exists()) {
      file.delete();
    }

    if (_sketches.isEmpty) {
      await newFile();
    } else {
      loadFile(filePath: _sketches.keys.first);
    }

    notifyListeners();
  }

  void clear() => sketch.cubeInfos.clear();

  Future<String> _loadAllSketches({bool ignoreCurrent = false}) async {
    final Directory appFolder = await getApplicationDocumentsDirectory();

    List<String> paths = await getAllAppFilePaths(appFolder);

    // display in reverse chronological order (most recent first)
    // this is because the file name is a number that increases with time.
    paths.sort((a, b) => b.compareTo(a));

    for (final String path in paths) {
      if (!(ignoreCurrent && path == currentFilePath)) {
        final File file = File(path);

        _sketches[path] = Sketch.fromString(await file.readAsString());
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
    final String appFolderPath = await _getAppFolderPath();

    return '$appFolderPath${Settings.fileName}';
  }

  Future<void> saveSettings() async =>
      saveString(filePath: settingsPath, string: _settings.toString());

  Future<void> copySamples() async {
    const assetsFolder = 'samples/';

    final String appFolderPath = await _getAppFolderPath();

    await Assets.copyAllFromTo(assetsFolder, appFolderPath,
        extensionReplacement: cubesExtension);
  }
}

class SlicesExample {
  late Sketch triangleWithGap;

  late Sketch triangleGap;

  UnitTransform get unitTransform => triangleWithGap.unitTransform;

  Future<void> init() async {
    final assets = await Assets.getStrings('help/triangle_');

    triangleWithGap = Sketch.fromString(assets['triangle_with_gap.json']!);
    triangleGap = Sketch.fromString(assets['triangle_gap.json']!);
  }
}
