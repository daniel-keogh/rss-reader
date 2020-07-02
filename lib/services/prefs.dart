import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static Prefs _instance;
  static SharedPreferences _prefs;

  Prefs._();

  static Future<Prefs> getInstance() async {
    _prefs = await SharedPreferences.getInstance();
    return _instance;
  }
}
