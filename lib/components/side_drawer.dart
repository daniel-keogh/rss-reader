import 'package:flutter/material.dart';

import 'package:rssreader/utils/routes.dart';

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
            const Divider(),
            ListTile(
              title: const Text('Sources'),
              leading: const Icon(Icons.library_add),
              onTap: () {
                Navigator.popAndPushNamed(context, Routes.sources);
              },
            ),
            ListTile(
              title: const Text('Favourites'),
              leading: const Icon(Icons.favorite_border),
              onTap: () {
                Navigator.popAndPushNamed(context, Routes.favourites);
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Settings'),
              leading: const Icon(Icons.settings),
              onTap: () {
                Navigator.popAndPushNamed(context, Routes.settings);
              },
            ),
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
      ),
    );
  }
}
