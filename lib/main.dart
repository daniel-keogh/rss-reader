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
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/catalog': (context) => CatalogScreen(),
        '/sources': (context) => SourcesScreen(),
        '/settings': (context) => SettingsScreen(),
      },
    );
  }
}
