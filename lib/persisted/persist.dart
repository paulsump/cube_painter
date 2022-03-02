import 'dart:io';

import 'package:cube_painter/out.dart';
import 'package:cube_painter/persisted/assets.dart';
import 'package:path_provider/path_provider.dart';

//TODO PUT MORE Persist stuff in here, making it a class e.g. PersistedSketch or Painting
// it could have the settings, appFolder etc

const cubesExtension = '.cubes.json';

Future<List<String>> getAllAppFilePaths(Directory appFolder) async {
  final paths = <String>[];

  await for (final FileSystemEntity fileSystemEntity in appFolder.list()) {
    final String path = fileSystemEntity.path;

    if (path.endsWith(cubesExtension)) {
      paths.add(path);
    }
  }
  return paths;
}

Future<String> getAppFolderPath() async {
  final Directory appFolder = await getApplicationDocumentsDirectory();

  return '${appFolder.path}${Platform.pathSeparator}';
}

Future<void> copySamples() async {
  const assetsFolder = 'samples/';

  final String appFolderPath = await getAppFolderPath();

  await Assets.copyAllFromTo(assetsFolder, appFolderPath,
      extensionReplacement: cubesExtension);
}

Future<String> loadString({required String filePath}) async {
  File file = File(filePath);

  // TODO check for empty string where i use this function?
  if (!await file.exists()) {
    out("File doesn't exist: $filePath");
    return '';
  }

  return await file.readAsString();
}

Future<void> saveString(
    {required String filePath, required String string}) async {
  assert(filePath.isNotEmpty);

  File file = File(filePath);
  await file.writeAsString(string);
}
