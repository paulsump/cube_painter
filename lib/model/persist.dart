// import 'dart:io';
//
// class Persist {
//
//   Future<String> load() async {
//     return await file.readAsString();
//   }
//
//   void save(String text) async {
//     try {
//       File file = File(await _getFilePath());
//       file.writeAsString(text);
//     } catch (e) {
//       // doesn't work on windows or mac
//     }
//   }
//
//   Future<String> _getFilePath() async {
//     Directory folder = await getApplicationDocumentsDirectory();
//
//     String path = folder.path;
//     return '$path/$_fileName';
//   }
// }
