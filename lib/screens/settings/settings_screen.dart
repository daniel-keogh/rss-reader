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
      body: Scrollbar(
        child: ListView(
          padding: const EdgeInsets.only(top: 10, bottom: 20),
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
            const Divider(),
            SettingsSection(
              title: "Behaviour",
              listTiles: <Widget>[
                CheckboxListTile(
                  title: const Text("Use external browser"),
                  subtitle: const Text(
                    "Open articles directly in your device's default web browser.",
                  ),
                  value: true,
                  isThreeLine: true,
                  onChanged: (value) {},
                ),
                CheckboxListTile(
                  title: const Text("Refresh on open"),
                  subtitle: const Text(
                    "Automatically refresh all your feeds when the app is launched.",
                  ),
                  value: true,
                  isThreeLine: true,
                  onChanged: (value) {},
                ),
              ],
            ),
            const Divider(),
            SettingsSection(
              title: "Caching",
              listTiles: <Widget>[
                ListTile(
                  title: const Text("Time to keep entries"),
                  subtitle: const Text(
                    "Set the amount of time articles will be stored.",
                  ),
                  onTap: () {},
                ),
                ListTile(
                  title: const Text("Article limit"),
                  subtitle: const Text(
                    'Set the maximum number of articles that will be stored on the device.',
                  ),
                  isThreeLine: true,
                  onTap: () {},
                ),
              ],
            ),
            const Divider(),
            SettingsSection(
              title: "History",
              listTiles: <Widget>[
                ListTile(
                  title: const Text("Clear reading history"),
                  onTap: () {},
                ),
              ],
            ),
            const Divider(),
            SettingsSection(
              title: "About",
              listTiles: <Widget>[
                AboutListTile(
                  icon: const Icon(Icons.info_outline),
                  child: const Text('About'),
                  applicationName: 'RSS Reader',
                  applicationVersion: '1.0.0',
                  applicationIcon: const Icon(Icons.rss_feed),
                  aboutBoxChildren: <Widget>[
                    const Text('A Simple RSS Reader.'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
