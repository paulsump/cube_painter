import 'package:cube_painter/shared/out.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Persist {
  static const String _name = 'cubes1';
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<String> loadJson() async {
    final SharedPreferences prefs = await _prefs;
    final String? json = prefs.getString(_name);
    return json ?? '';
  }

  Future<void> saveJson(String json) async {
    try {
      final SharedPreferences prefs = await _prefs;

      await prefs.setString(_name, json);
    } catch (e) {
      out(e);
    }
  }
}
