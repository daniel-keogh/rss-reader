import 'package:flutter/foundation.dart';

import 'package:shared_preferences/shared_preferences.dart';

enum OpenIn {
  internal,
  external,
}

class SettingsProvider extends ChangeNotifier {
  OpenIn _openIn = OpenIn.external;
  bool _refreshOnOpen = true;

  static const String _OPEN_IN_APP = "open-in-app";
  static const String _REFRESH_ON_OPEN = "refresh-on-open";

  SettingsProvider() {
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();

    try {
      _openIn = prefs.getBool(_OPEN_IN_APP) ? OpenIn.internal : OpenIn.external;
    } catch (_) {
      _openIn = OpenIn.internal;
    }

    try {
      _refreshOnOpen = prefs.getBool(_REFRESH_ON_OPEN);
    } catch (_) {
      _refreshOnOpen = true;
    }

    notifyListeners();
  }

  get openIn => _openIn;

  set openIn(OpenIn value) {
    _openIn = value;

    notifyListeners();

    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool(_OPEN_IN_APP, _openIn == OpenIn.internal);
    });
  }

  get refreshOnOpen => _refreshOnOpen;

  set refreshOnOpen(bool value) {
    _refreshOnOpen = value;

    notifyListeners();

    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool(_REFRESH_ON_OPEN, _refreshOnOpen);
    });
  }
}
