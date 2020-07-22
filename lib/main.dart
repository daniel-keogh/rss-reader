import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:rssreader/providers/subscriptions.dart';
import 'package:rssreader/providers/theme_changer.dart';
import 'package:rssreader/services/prefs.dart';
import 'package:rssreader/theme/style.dart';
import 'package:rssreader/screens/home/home_screen.dart';
import 'package:rssreader/screens/catalog/catalog_screen.dart';
import 'package:rssreader/screens/sources/sources_screen.dart';
import 'package:rssreader/screens/settings/settings_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Prefs.getInstance().then((prefs) {
    runApp(RssReader(
      activeTheme: prefs.getActiveTheme(),
    ));
  });
}

class RssReader extends StatelessWidget {
  static const String _title = 'RSS Reader';

  final ActiveTheme activeTheme;

  RssReader({
    Key key,
    @required this.activeTheme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeChanger(activeTheme)),
        ChangeNotifierProvider(create: (context) => SubscriptionsProvider()),
      ],
      child: Builder(
        builder: (context) => MaterialApp(
          title: RssReader._title,
          theme: Provider.of<ThemeChanger>(context).theme == ActiveTheme.light
              ? Style.getThemeData()
              : Style.getDarkThemeData(),
          initialRoute: HomeScreen.route,
          routes: {
            HomeScreen.route: (context) => HomeScreen(),
            CatalogScreen.route: (context) => CatalogScreen(),
            SourcesScreen.route: (context) => SourcesScreen(),
            SettingsScreen.route: (context) => SettingsScreen(),
          },
        ),
      ),
    );
  }
}
