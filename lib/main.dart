import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:rssreader/providers/articles_provider.dart';
import 'package:rssreader/providers/favourites_provider.dart';
import 'package:rssreader/providers/settings_provider.dart';
import 'package:rssreader/providers/subscriptions_provider.dart';
import 'package:rssreader/providers/theme_provider.dart';
import 'package:rssreader/screens/catalog/catalog_screen.dart';
import 'package:rssreader/screens/favourites/favourites_screen.dart';
import 'package:rssreader/screens/home/home_screen.dart';
import 'package:rssreader/screens/settings/settings_screen.dart';
import 'package:rssreader/screens/sources/sources_screen.dart';
import 'package:rssreader/theme/style.dart';
import 'package:rssreader/utils/routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  ThemeProvider.getPreferredTheme().then((theme) {
    runApp(
      RssReader(activeTheme: theme),
    );
  });
}

class RssReader extends StatelessWidget {
  static const String title = 'RSS Reader';

  final ActiveTheme activeTheme;

  RssReader({
    Key key,
    @required this.activeTheme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider(activeTheme)),
        ChangeNotifierProvider(create: (context) => SubscriptionsProvider()),
        ChangeNotifierProvider(create: (context) => FavouritesProvider()),
        ChangeNotifierProvider(create: (context) => SettingsProvider()),
        ChangeNotifierProxyProvider<SubscriptionsProvider, ArticlesProvider>(
          create: (context) => ArticlesProvider(),
          update: (context, subscriptions, articles) {
            articles.subsProv = subscriptions;
            articles.update();
            return articles;
          },
        ),
      ],
      child: Builder(
        builder: (context) => MaterialApp(
          title: RssReader.title,
          theme: Provider.of<ThemeProvider>(context).theme == ActiveTheme.light
              ? Style.getThemeData()
              : Style.getDarkThemeData(),
          initialRoute: Routes.home,
          routes: {
            Routes.home: (context) => HomeScreen(),
            Routes.catalog: (context) => CatalogScreen(),
            Routes.favourites: (context) => FavouritesScreen(),
            Routes.settings: (context) => SettingsScreen(),
            Routes.sources: (context) => SourcesScreen(),
          },
        ),
      ),
    );
  }
}
