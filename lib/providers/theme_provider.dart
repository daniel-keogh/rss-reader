import 'package:flutter/foundation.dart';

import 'package:shared_preferences/shared_preferences.dart';

enum ActiveTheme {
  light,
  dark,
}

class ThemeProvider extends ChangeNotifier {
  ActiveTheme _theme;

  static const String _THEME = 'dark-theme';

  ThemeProvider(this._theme);

  static Future<ActiveTheme> getPreferredTheme() async {
    final prefs = await SharedPreferences.getInstance();

    try {
      return prefs.getBool(_THEME) ? ActiveTheme.dark : ActiveTheme.light;
    } catch (_) {
      return ActiveTheme.light;
    }
  }

  ActiveTheme get theme => _theme;

  set theme(ActiveTheme theme) {
    _theme = theme;

    notifyListeners();

    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool(_THEME, _theme == ActiveTheme.dark);
    });
  }
}
