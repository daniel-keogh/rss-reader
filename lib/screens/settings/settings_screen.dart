import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:rssreader/screens/settings/settings_section.dart';
import 'package:rssreader/providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            SettingsSection(
              title: "Appearance",
              listTiles: <Widget>[
                Consumer<ThemeProvider>(
                  builder: (context, prov, child) => SwitchListTile(
                    title: const Text("Dark theme"),
                    secondary: const Icon(Icons.brightness_4),
                    value: prov.theme == ActiveTheme.dark,
                    onChanged: (value) {
                      prov.theme = value ? ActiveTheme.dark : ActiveTheme.light;
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
