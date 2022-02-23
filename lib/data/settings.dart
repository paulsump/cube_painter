class Settings {
  String currentFileName;
  bool showCrops;

  Settings.fromJson(Map<String, dynamic> json)
      : currentFileName = json['currentFileName'],
        showCrops = json['showCrops'];

  Map<String, dynamic> toJson() => {
        'currentFileName': currentFileName,
        'showCrops': showCrops,
      };
}
