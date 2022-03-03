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
  final paintings = <String, Painting>{};

  final slicesExample = _SlicesExample();

  String get json => painting.toString();

  final _settingsPersister = SettingsPersister();
  late Settings _settings;

  String _savedJson = '';

  bool get modified => json != _savedJson;

  bool get hasCubes =>
      paintings.isNotEmpty &&
      _hasPaintingForCurrentFilePath &&
      painting.cubeInfos.isNotEmpty;

  bool get _hasPaintingForCurrentFilePath {
    if (!paintings.containsKey(currentFilePath)) {
      out(currentFilePath);

      return false;
    }
    return true;
  }

  /// defined in [Animator]
  void finishAnim();

  /// defined in [PaintingBank]
  void updateAfterLoad(BuildContext context);

  String get currentFilePath => _settings.currentFilePath;

  void saveCurrentFilePath(String filePath) {
    _settings.currentFilePath = filePath;

    unawaited(_settingsPersister.save());
  }

  Painting get painting {
    if (!_hasPaintingForCurrentFilePath) {
      assert(false,
          "paintings doesn't contain key of currentFilePath: $currentFilePath");

      // prevent irreversible crash for now, for debugging purposes.
      return Painting.fromEmpty();
    }
    return paintings[currentFilePath]!;
  }

  void setPainting(Painting painting) => paintings[currentFilePath] = painting;

  UnmodifiableListView<MapEntry> get paintingEntries =>
      UnmodifiableListView<MapEntry>(paintings.entries.toList());

  /// The main starting point for the app.
  Future<void> init(BuildContext context) async {
    _settings = await _settingsPersister.load();

    if (!_settings.copiedSamples) {
      await copySamples();

      _settings.copiedSamples = true;
      await _settingsPersister.save();
    }

    final firstPath = await _loadAllPaintings();

    if (currentFilePath.isEmpty) {
      //  Most recently created is now first in list
      saveCurrentFilePath(firstPath);
    }

    if (!paintings.containsKey(currentFilePath)) {
      out("currentFilePath not found ('$currentFilePath'), so using the first in the list");

      saveCurrentFilePath(firstPath);
    }

    _savedJson = json;
    updateAfterLoad(context);

    unawaited(slicesExample.init());
  }

  // insert at the top of the list
  void pushPainting(Painting painting) {
    final copy = Map<String, Painting>.from(paintings);

    paintings.clear();
    setPainting(painting);

    paintings.addAll(copy);
  }

  Future<void> newFile(BuildContext context) async {
    finishAnim();

    await _setNewFilePath();

    pushPainting(Painting.fromEmpty());
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
    pushPainting(Painting.fromString(jsonCopy));

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

  Future<void> resetCurrentPainting() async =>
      paintings[currentFilePath] = Painting.fromString(_savedJson);

  void clear() => painting.cubeInfos.clear();

  Future<String> _loadAllPaintings({bool ignoreCurrent = false}) async {
    final Directory appFolder = await getApplicationDocumentsDirectory();

    List<String> paths = await getAllAppFilePaths(appFolder);

    // display in reverse chronological order (most recent first)
    // this is because the file name is a number that increases with time.
    paths.sort((a, b) => b.compareTo(a));

    for (final String path in paths) {
      if (!(ignoreCurrent && path == currentFilePath)) {
        final File file = File(path);

        paintings[path] = Painting.fromString(await file.readAsString());
      }
    }

    return paths.first;
  }

  Future<void> deleteCurrentFile(BuildContext context) async {
    paintings.remove(currentFilePath);

    final File file = File(currentFilePath);

    // we might never have saved a new filename, so check existence
    if (await file.exists()) {
      file.delete();
    }

    if (paintings.isEmpty) {
      await newFile(context);
    } else {
      loadFile(filePath: paintings.keys.first, context: context);
    }
  }
}

class _SlicesExample {
  late UnitTransform unitTransform;

  late Painting triangleWithGap;
  late Painting triangleGap;

  Future<void> init() async {
    final assets = await Assets.getStrings('help/triangle_');

    triangleWithGap = Painting.fromString(assets['triangle_with_gap.json']!);
    triangleGap = Painting.fromString(assets['triangle_gap.json']!);

    unitTransform = triangleWithGap.unitTransform;
  }
}
