import 'dart:convert';
import 'dart:io';

import 'package:cube_painter/persisted/persist.dart';

class Settings {
  String currentFilePath;

  bool copiedSamples;

  static const String fileName = 'settings.json';

  Settings.fromString(String json) : this.fromJson(jsonDecode(json));

  @override
  String toString() => jsonEncode(this);

  Settings.fromJson(Map<String, dynamic> json)
      : currentFilePath = json['currentFilePath'],
        copiedSamples = json['copiedSamples'];

  Map<String, dynamic> toJson() => {
        'currentFilePath': currentFilePath,
        'copiedSamples': copiedSamples,
      };
}

class SettingsPersister {
  late String _path;
  late Settings _settings;

  Future<Settings> load() async {
    _path = await _getSettingsPath();

    // if(true){
    if (!await File(_path).exists()) {
      _settings = Settings.fromJson({
        'currentFilePath': '',
        'copiedSamples': false,
      });
    } else {
      _settings = Settings.fromString(await loadString(filePath: _path));
    }

    return _settings;
  }

  Future<void> save() async =>
      saveString(filePath: _path, string: _settings.toString());

  Future<String> _getSettingsPath() async {
    final String appFolderPath = await getAppFolderPath();

    return '$appFolderPath${Settings.fileName}';
  }
}
