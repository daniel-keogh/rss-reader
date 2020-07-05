import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:rssreader/components/settings_section.dart';
import 'package:rssreader/providers/theme_changer.dart';

class SettingsScreen extends StatelessWidget {
  static const String route = '/settings';

  @override
  Widget build(BuildContext context) {
    var _themeChanger = Provider.of<ThemeChanger>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            SettingsSection(
              title: "Appearance",
              listTiles: <Widget>[
                SwitchListTile(
                  title: Text("Dark theme"),
                  secondary: Icon(Icons.brightness_4),
                  value: _themeChanger.theme == ActiveTheme.dark,
                  onChanged: (value) {
                    _themeChanger.theme =
                        value ? ActiveTheme.dark : ActiveTheme.light;
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
