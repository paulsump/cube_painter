class Settings {
  String currentFilePath;
  bool showCrops;

  Settings.fromJson(Map<String, dynamic> json)
      : currentFilePath = json['currentFilePath'],
        showCrops = json['showCrops'];

  Map<String, dynamic> toJson() => {
        'currentFilePath': currentFilePath,
        'showCrops': showCrops,
      };
}
