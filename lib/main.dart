import 'package:flutter/material.dart';

import 'package:rssreader/theme/style.dart';
import 'package:rssreader/screens/home_screen.dart';
import 'package:rssreader/screens/catalog_screen.dart';
import 'package:rssreader/screens/sources_screen.dart';
import 'package:rssreader/screens/settings_screen.dart';

void main() => runApp(RssReader());

class RssReader extends StatelessWidget {
  static const String _title = 'RSS Reader';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      theme: Style.getThemeData(),
      darkTheme: Style.getDarkThemeData(),
      initialRoute: HomeScreen.route,
      routes: {
        HomeScreen.route: (context) => HomeScreen(),
        CatalogScreen.route: (context) => CatalogScreen(),
        SourcesScreen.route: (context) => SourcesScreen(),
        SettingsScreen.route: (context) => SettingsScreen(),
      },
    );
  }
}
