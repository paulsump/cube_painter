import 'dart:convert';

class Settings {
  String currentFilePath;

  bool showCrops;
  bool copiedSamples;

  Settings.fromString(String json) : this.fromJson(jsonDecode(json));

  @override
  String toString() => jsonEncode(this);

  Settings.fromJson(Map<String, dynamic> json)
      : currentFilePath = json['currentFilePath'],
        copiedSamples = json['copiedSamples'],
        showCrops = json['showCrops'];

  Map<String, dynamic> toJson() => {
        'currentFilePath': currentFilePath,
        'copiedSamples': copiedSamples,
        'showCrops': showCrops,
      };
}
