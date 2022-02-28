import 'dart:convert';

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
