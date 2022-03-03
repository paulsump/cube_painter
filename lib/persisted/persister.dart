import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:cube_painter/out.dart';
import 'package:cube_painter/persisted/assets.dart';
import 'package:cube_painter/persisted/cube_info.dart';
import 'package:cube_painter/persisted/painting.dart';
import 'package:cube_painter/persisted/persist.dart';
import 'package:cube_painter/persisted/settings.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

const noWarn = out;

/// The main store of the entire model
/// For loading and saving all the cube positions and their info
/// loaded from a json file.
/// init() is the main starting point for the app.
mixin Persister {
  @protected
  final paintinges = <String, Sketch>{};

  final slicesExample = _SlicesExample();

  String get json => painting.toString();

  final _settingsPersister = SettingsPersister();
  late Settings _settings;

  String _savedJson = '';

  bool get modified => json != _savedJson;

  bool get hasCubes =>
      paintinges.isNotEmpty &&
      _hasSketchForCurrentFilePath &&
      painting.cubeInfos.isNotEmpty;

  bool get _hasSketchForCurrentFilePath {
    if (!paintinges.containsKey(currentFilePath)) {
      out(currentFilePath);

      return false;
    }
    return true;
  }

  /// defined in [Animator]
  void finishAnim();

  /// defined in [SketchBank]
  void updateAfterLoad(BuildContext context);

  String get currentFilePath => _settings.currentFilePath;

  void saveCurrentFilePath(String filePath) {
    _settings.currentFilePath = filePath;

    unawaited(_settingsPersister.save());
  }

  Sketch get painting {
    if (!_hasSketchForCurrentFilePath) {
      assert(false,
          "paintinges doesn't contain key of currentFilePath: $currentFilePath");

      // prevent irreversible crash for now, for debugging purposes.
      return Sketch.fromEmpty();
    }
    return paintinges[currentFilePath]!;
  }

  void setSketch(Sketch painting) => paintinges[currentFilePath] = painting;

  UnmodifiableListView<MapEntry> get paintingEntries =>
      UnmodifiableListView<MapEntry>(paintinges.entries.toList());

  /// The main starting point for the app.
  Future<void> init(BuildContext context) async {
    _settings = await _settingsPersister.load();

    if (!_settings.copiedSamples) {
      await copySamples();

      _settings.copiedSamples = true;
      await _settingsPersister.save();
    }

    final firstPath = await _loadAllSketches();

    if (currentFilePath.isEmpty) {
      //  Most recently created is now first in list
      saveCurrentFilePath(firstPath);
    }

    if (!paintinges.containsKey(currentFilePath)) {
      out("currentFilePath not found ('$currentFilePath'), so using the first in the list");

      saveCurrentFilePath(firstPath);
    }

    _savedJson = json;
    updateAfterLoad(context);

    unawaited(slicesExample.init());
  }

  // insert at the top of the list
  void pushSketch(Sketch painting) {
    final copy = Map<String, Sketch>.from(paintinges);

    paintinges.clear();
    setSketch(painting);

    paintinges.addAll(copy);
  }

  Future<void> newFile(BuildContext context) async {
    finishAnim();

    await _setNewFilePath();

    pushSketch(Sketch.fromEmpty());
    _savedJson = json;

    updateAfterLoad(context);
    unawaited(saveFile());
  }

  void loadFile({required String filePath, required BuildContext context}) {
    saveCurrentFilePath(filePath);

    _savedJson = json;
    updateAfterLoad(context);
  }

  Future<void> saveFile() async {
    finishAnim();

    await saveString(filePath: currentFilePath, string: json);
    _savedJson = json;
  }

  Future<void> saveACopyFile() async {
    finishAnim();

    final jsonCopy = json;

    await _setNewFilePath();
    pushSketch(Sketch.fromString(jsonCopy));

    _savedJson = json;
    unawaited(saveFile());
  }

  void addCubeInfo(CubeInfo info) => painting.cubeInfos.add(info);

  Future<void> _setNewFilePath() async {
    final String appFolderPath = await getAppFolderPath();

    final int uniqueId =
        (DateTime.now().millisecondsSinceEpoch - 1645648060000) ~/ 100;

    saveCurrentFilePath('$appFolderPath$uniqueId$cubesExtension');
  }

  Future<void> resetCurrentSketch() async =>
      paintinges[currentFilePath] = Sketch.fromString(_savedJson);

  void clear() => painting.cubeInfos.clear();

  Future<String> _loadAllSketches({bool ignoreCurrent = false}) async {
    final Directory appFolder = await getApplicationDocumentsDirectory();

    List<String> paths = await getAllAppFilePaths(appFolder);

    // display in reverse chronological order (most recent first)
    // this is because the file name is a number that increases with time.
    paths.sort((a, b) => b.compareTo(a));

    for (final String path in paths) {
      if (!(ignoreCurrent && path == currentFilePath)) {
        final File file = File(path);

        paintinges[path] = Sketch.fromString(await file.readAsString());
      }
    }

    return paths.first;
  }

  Future<void> deleteCurrentFile(BuildContext context) async {
    paintinges.remove(currentFilePath);

    final File file = File(currentFilePath);

    // we might never have saved a new filename, so check existence
    if (await file.exists()) {
      file.delete();
    }

    if (paintinges.isEmpty) {
      await newFile(context);
    } else {
      loadFile(filePath: paintinges.keys.first, context: context);
    }
  }
}

class _SlicesExample {
  late UnitTransform unitTransform;

  late Sketch triangleWithGap;
  late Sketch triangleGap;

  Future<void> init() async {
    final assets = await Assets.getStrings('help/triangle_');

    triangleWithGap = Sketch.fromString(assets['triangle_with_gap.json']!);
    triangleGap = Sketch.fromString(assets['triangle_gap.json']!);

    unitTransform = triangleWithGap.unitTransform;
  }
}
