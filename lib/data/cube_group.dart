import 'dart:convert';
import 'dart:io';

import 'package:cube_painter/data/assets.dart';
import 'package:cube_painter/data/cube_info.dart';
import 'package:cube_painter/data/file.dart';
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
  // final _cubeGroups = <CubeGroup>[const CubeGroup([])];
  final _cubeGroups = <CubeGroup>[];

  bool get hasCubes => _cubeGroups.isNotEmpty && cubeGroup.cubeInfos.isNotEmpty;

  late Persisted persisted;

  late VoidCallback _onSuccessfulLoad;
  final _exampleFilePaths = <String>[];

  late List<String> allImagePaths;

  String get currentName {
    final path = _exampleFilePaths[_currentIndex];

    out(path);
    return path.split("/").last.replaceFirst('.json', '');
  }

  int _currentIndex = 0;

  CubeGroup get cubeGroup => _cubeGroups[_currentIndex];

  set cubeGroup(value) => _cubeGroups[_currentIndex] = value;

  List<CubeGroup> get cubeGroups => _cubeGroups;

  void init({
    required String examplesFolderPath,
    required VoidCallback onSuccessfulLoad,
  }) async {
    allImagePaths = await getAllImagePaths();

    _exampleFilePaths.addAll(await Assets.getFilePaths(examplesFolderPath));
    assert(_exampleFilePaths.isNotEmpty);

    _onSuccessfulLoad = onSuccessfulLoad;
    persisted = Persisted(fileName: "persisted1.json");

    await _loadAllCubeGroups();
    // out(cubeGroup.cubeInfos.length);

    // TODO load previous run's file,
    _updateAfterLoad();
    // not an example every time
    // await _loadExampleCubeGroup(_exampleFilePaths[_currentIndex],
    //     onSuccess: _updateAfterLoad);
  }

  void _loadExampleCubeGroup(String filePath,
      {required VoidCallback onSuccess}) async {
    final map = await Assets.loadJson(filePath);

    cubeGroup = CubeGroup.fromJson(map);
    onSuccess();
  }

  void _loadPersistedCubeGroup(String json,
      {required VoidCallback onSuccess}) async {
    Map<String, dynamic> map = jsonDecode(json);

    cubeGroup = CubeGroup.fromJson(map);
    onSuccess();
  }

  void _updateAfterLoad() {
    // TODO if fail, alert user, perhaps skip
    // TODO iff finally:
    _onSuccessfulLoad();
    // TODO clear undo (make undoer a notifier and notifyListeners for button enabled.
    notifyListeners();
  }

  String get json => jsonEncode(cubeGroup);

  void load() async {
    String filePath = await persisted.load();
    _loadPersistedCubeGroup(filePath, onSuccess: _updateAfterLoad);
  }

  void loadPersisted(Persisted newPersisted) async {
    String filePath = await newPersisted.load();

    _loadPersistedCubeGroup(filePath, onSuccess: () {
      persisted = newPersisted;
      _updateAfterLoad();
    });
  }

  void save() => persisted.save(json);

  void loadNextExample() => increment(1);

  void increment(int increment) {
    assert(1 == increment);

    _currentIndex += increment;
    _currentIndex %= _exampleFilePaths.length;

    final String filePath = _exampleFilePaths[_currentIndex];

    _loadExampleCubeGroup(filePath, onSuccess: _updateAfterLoad);
  }

  void addCubeInfo(CubeInfo info) => cubeGroup.cubeInfos.add(info);

  void convertAll() {
    const String folderPath = '/Users/paulsump/a/cube_painter/';

    for (int i = 0; i < _exampleFilePaths.length; ++i) {
      final String filePath = _exampleFilePaths[i];

      _loadExampleCubeGroup(filePath,
          onSuccess: () => _save(folderPath + filePath));
    }
  }

  void _save(String fullFilePath) {
    out(fullFilePath);

    File(fullFilePath).writeAsString(json);
  }

  void createPersisted() {
    //todo createPersisted
    //TODO REMOve
    // clear();
    //     _updateAfterLoad();
  }

  void clear() {
    // if (cubeGroup.cubeInfos.isNotEmpty) {
    cubeGroup.cubeInfos.clear();
    // }
  }

  Future<void> _loadAllCubeGroups() async {
    final Directory folder = await getApplicationDocumentsDirectory();

    await for (final FileSystemEntity f in folder.list()) {
      if (f.path.endsWith('.json')) {
        // out(f.path);
        File file = File(f.path);

        String json = await file.readAsString();
        final map = jsonDecode(json);
        _cubeGroups.add(CubeGroup.fromJson(await map));
      }
    }

    await for (final json in Assets.loadAll('data')) {
      _cubeGroups.add(CubeGroup.fromJson(await json));
    }
  }
}
