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
  // todo rename to path
  late String settingsPath;
  late Settings _settings;

  Future<Settings> init() async {
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

    return _settings;
  }

//TODO MAKE private
  Future<String> getSettingsPath() async {
    final String appFolderPath = await getAppFolderPath();

    return '$appFolderPath${Settings.fileName}';
  }

  // TODO rename to save()
  Future<void> saveSettings() async =>
      saveString(filePath: settingsPath, string: _settings.toString());
}
