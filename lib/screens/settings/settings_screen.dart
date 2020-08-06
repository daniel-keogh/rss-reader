import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:rssreader/providers/articles_provider.dart';

import 'package:rssreader/screens/settings/settings_section.dart';
import 'package:rssreader/providers/settings_provider.dart';
import 'package:rssreader/providers/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double currentValue = 500.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Scrollbar(
        child: Consumer<SettingsProvider>(
          builder: (context, model, child) => ListView(
            padding: const EdgeInsets.only(top: 10, bottom: 20),
            children: <Widget>[
              SettingsSection(
                title: 'Appearance',
                children: <Widget>[
                  Consumer<ThemeProvider>(
                    builder: (context, prov, child) => SwitchListTile(
                      title: const Text('Dark theme'),
                      secondary: const Icon(Icons.brightness_4),
                      value: prov.theme == ActiveTheme.dark,
                      onChanged: (value) {
                        prov.theme =
                            value ? ActiveTheme.dark : ActiveTheme.light;
                      },
                    ),
                  ),
                ],
              ),
              const Divider(),
              SettingsSection(
                title: 'Behaviour',
                children: <Widget>[
                  CheckboxListTile(
                    title: const Text('Use external browser'),
                    subtitle: const Text(
                      "Open articles directly in your device's default web browser.",
                    ),
                    isThreeLine: true,
                    value: model.openIn == OpenIn.external,
                    onChanged: (value) {
                      model.openIn = value ? OpenIn.external : OpenIn.internal;
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Refresh on open'),
                    subtitle: const Text(
                      'Automatically refresh all your feeds when the app is launched.',
                    ),
                    isThreeLine: true,
                    value: model.refreshOnOpen,
                    onChanged: (value) => model.refreshOnOpen = value,
                  ),
                ],
              ),
              const Divider(),
              SettingsSection(
                title: 'Caching',
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      ListTile(
                        title: const Text('Article limit'),
                        subtitle: const Text(
                          'Set the maximum number of articles that will be stored on the device.',
                        ),
                        isThreeLine: true,
                      ),
                      StatefulBuilder(
                        builder: (context, setState) => Slider(
                          label: '${currentValue.toInt()}',
                          value: currentValue,
                          min: 500.0,
                          max: 3000.0,
                          divisions: 5,
                          onChanged: (value) {
                            setState(() => currentValue = value);
                          },
                          onChangeEnd: (value) {
                            print(value);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(),
              SettingsSection(
                title: 'History',
                children: <Widget>[
                  ListTile(
                    title: const Text('Clear reading history'),
                    onTap: () {
                      setState(() {
                        Provider.of<ArticlesProvider>(
                          context,
                          listen: false,
                        ).updateStatus(false);
                      });
                    },
                  ),
                ],
              ),
              const Divider(),
              SettingsSection(
                title: 'About',
                children: <Widget>[
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
      ),
    );
  }
}
