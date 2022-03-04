import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:cube_painter/out.dart';
import 'package:cube_painter/persisted/painting.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

const noWarn = out;

const cubesExtension = '.cubes.json';

/// The main store of the entire model
/// For loading and saving all the cube positions and their info
/// loaded from a json file.
mixin Persister {
  @protected
  final paintings = <String, Painting>{};

  final slicesExample = _SlicesExamplePainting();

  String get json => painting.toString();

  final _settingsPersister = _SettingsPersister();
  late _Settings _settings;

  String _savedJson = '';

  bool get modified => json != _savedJson;

  bool get hasCubes =>
      paintings.isNotEmpty &&
      _hasPaintingForCurrentFilePath &&
      painting.cubeInfos.isNotEmpty;

  bool get _hasPaintingForCurrentFilePath {
    if (!paintings.containsKey(currentFilePath)) {
      out('_hasPaintingForCurrentFilePath : File not loaded (yet?): $currentFilePath');

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
  /// Called only once.
  Future<void> setup(BuildContext context) async {
    _settings = await _settingsPersister.load();

    if (!_settings.copiedSamples) {
      await _copySamples(assetsFolder: 'samples/');

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

    unawaited(slicesExample.load());
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

  void notify();

  Future<void> saveFile() async {
    finishAnim();

    await _saveString(filePath: currentFilePath, string: json);
    _savedJson = json;

    notify();
  }

  Future<void> saveACopyFile() async {
    finishAnim();

    final jsonCopy = json;
    await _setNewFilePath();

    pushPainting(Painting.fromString(jsonCopy));
    _savedJson = json;

    unawaited(saveFile());
  }

  Future<void> _setNewFilePath() async {
    final String appFolderPath = await _getAppFolderPath();

    final int uniqueId =
        (DateTime.now().millisecondsSinceEpoch - 1645648060000) ~/ 100;

    saveCurrentFilePath('$appFolderPath$uniqueId$cubesExtension');
  }

  Future<void> resetCurrentPainting() async =>
      paintings[currentFilePath] = Painting.fromString(_savedJson);

  Future<String> _loadAllPaintings({bool ignoreCurrent = false}) async {
    final Directory appFolder = await getApplicationDocumentsDirectory();

    List<String> paths = await _getAllAppFilePaths(appFolder);

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

/// The little animated triangle painting, on the [SlicesMenu]
/// Here because it's loaded from [_Assets].
class _SlicesExamplePainting {
  late UnitTransform unitTransform;

  late Painting triangleWithGap;
  late Painting triangleGap;

  Future<void> load() async {
    final assets = await _Assets._getStrings('help/triangle_');

    triangleWithGap = Painting.fromString(assets['triangle_with_gap.json']!);
    triangleGap = Painting.fromString(assets['triangle_gap.json']!);

    unitTransform = triangleWithGap.unitTransform;
  }
}

class _Settings {
  String currentFilePath;

  bool copiedSamples;

  static const String fileName = 'settings.json';

  _Settings.fromString(String json) : this.fromJson(jsonDecode(json));

  @override
  String toString() => jsonEncode(this);

  _Settings.fromJson(Map<String, dynamic> json)
      : currentFilePath = json['currentFilePath'],
        copiedSamples = json['copiedSamples'];

  Map<String, dynamic> toJson() => {
        'currentFilePath': currentFilePath,
        'copiedSamples': copiedSamples,
      };
}

class _SettingsPersister {
  late String _path;
  late _Settings _settings;

  Future<_Settings> load() async {
    _path = await _getSettingsPath();

    // if(true){
    if (!await File(_path).exists()) {
      _settings = _Settings.fromJson({
        'currentFilePath': '',
        'copiedSamples': false,
      });
    } else {
      _settings = _Settings.fromString(await _loadString(filePath: _path));
    }

    return _settings;
  }

  Future<void> save() async =>
      _saveString(filePath: _path, string: _settings.toString());

  Future<String> _getSettingsPath() async {
    final String appFolderPath = await _getAppFolderPath();

    return '$appFolderPath${_Settings.fileName}';
  }
}

/// loading and copying asset files
class _Assets {
  /// return map of filename + loaded string
  static Future<Map<String, String>> _getStrings(String pathStartsWith) async {
    final manifestJson = await rootBundle.loadString('AssetManifest.json');

    final allFilePaths = jsonDecode(manifestJson).keys;
    final filePaths = <String, String>{};

    for (final String filePath in allFilePaths) {
      if (filePath.startsWith(pathStartsWith)) {
        final fileName = filePath.split(Platform.pathSeparator).last;

        filePaths[fileName] = await rootBundle.loadString(filePath);
      }
    }
    return filePaths;
  }

  static Future<void> _copyAllFromTo(
      String fromAssetFolderPathStartsWith, String toAppFolderPath) async {
    final assetFilePaths = await _getStrings(fromAssetFolderPathStartsWith);

    for (MapEntry asset in assetFilePaths.entries) {
      final assetFileName = asset.key;

      final appFileName = assetFileName.replaceFirst('.json', cubesExtension);

      final String appFilePath = '$toAppFolderPath$appFileName';
      File appFile = File(appFilePath);

      if (!await appFile.exists()) {
        out('copying $appFilePath');

        await appFile.writeAsString(asset.value);
      }
    }
  }
}

/// General persist helpers...

/// cont doc comment from HERE
Future<List<String>> _getAllAppFilePaths(Directory appFolder) async {
  final paths = <String>[];

  await for (final FileSystemEntity fileSystemEntity in appFolder.list()) {
    final String path = fileSystemEntity.path;

    if (path.endsWith(cubesExtension)) {
      paths.add(path);
    }
  }
  return paths;
}

Future<String> _getAppFolderPath() async {
  final Directory appFolder = await getApplicationDocumentsDirectory();

  return '${appFolder.path}${Platform.pathSeparator}';
}

Future<void> _copySamples({required String assetsFolder}) async =>
    await _Assets._copyAllFromTo(assetsFolder, await _getAppFolderPath());

Future<String> _loadString({required String filePath}) async {
  File file = File(filePath);

  // TODO check for empty string where i use this function?
  if (!await file.exists()) {
    out("File doesn't exist: $filePath");
    return '';
  }

  return await file.readAsString();
}

Future<void> _saveString(
    {required String filePath, required String string}) async {
  assert(filePath.isNotEmpty);

  File file = File(filePath);
  await file.writeAsString(string);
}
