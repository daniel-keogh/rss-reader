import 'package:flutter/foundation.dart';

import 'package:rssreader/services/prefs.dart';

enum ActiveTheme {
  light,
  dark,
}

class ThemeChanger extends ChangeNotifier {
  ActiveTheme _theme;

  ThemeChanger(this._theme);

  get theme {
    return _theme;
  }

  set theme(ActiveTheme theme) {
    _theme = theme;

    notifyListeners();

    Prefs.getInstance().then(
      (prefs) => prefs.setActiveTheme(_theme),
    );
  }
}
