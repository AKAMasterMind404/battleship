import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static addStringValueForKey(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
    return value;
  }

  static Future<dynamic> getStringValueForKey(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(key);
    return data;
  }

  static deleteStringValueForKey(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final data = prefs.remove(key);
    return data;
  }
}
