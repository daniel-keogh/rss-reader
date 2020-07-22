import 'package:flutter/foundation.dart';

import 'package:rssreader/services/prefs.dart';

enum ActiveTheme {
  light,
  dark,
}

class ThemeProvider extends ChangeNotifier {
  ActiveTheme _theme;

  ThemeProvider(this._theme);

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
