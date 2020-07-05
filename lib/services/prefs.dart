import 'package:shared_preferences/shared_preferences.dart';

import 'package:rssreader/providers/theme_changer.dart';

class Prefs {
  static Prefs _instance = Prefs._();
  static SharedPreferences _prefs;

  static const String _THEME = "dark-theme";

  Prefs._();

  static Future<Prefs> getInstance() async {
    _prefs = await SharedPreferences.getInstance();
    return _instance;
  }

  ActiveTheme getActiveTheme() {
    try {
      return _prefs.getBool(_THEME) ? ActiveTheme.dark : ActiveTheme.light;
    } catch (e) {
      return ActiveTheme.light;
    }
  }

  Future setActiveTheme(ActiveTheme activeTheme) async {
    await _prefs.setBool(_THEME, activeTheme == ActiveTheme.dark);
  }
}
