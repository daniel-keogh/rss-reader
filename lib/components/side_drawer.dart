import 'package:flutter/material.dart';

import 'package:rssreader/screens/settings/settings_screen.dart';
import 'package:rssreader/screens/sources/sources_screen.dart';

class SideDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text(
                'RSS Reader',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
            Divider(),
            ListTile(
              title: Text('Sources'),
              leading: Icon(Icons.library_add),
              onTap: () {
                Navigator.popAndPushNamed(context, SourcesScreen.route);
              },
            ),
            Divider(),
            ListTile(
              title: Text('Settings'),
              leading: Icon(Icons.settings),
              onTap: () {
                Navigator.popAndPushNamed(context, SettingsScreen.route);
              },
            ),
            AboutListTile(
              icon: Icon(Icons.info_outline),
              child: Text('About'),
              applicationName: 'RSS Reader',
              applicationVersion: '1.0.0',
              applicationIcon: Icon(Icons.rss_feed),
              aboutBoxChildren: <Widget>[
                Text('A Simple RSS Reader.'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
