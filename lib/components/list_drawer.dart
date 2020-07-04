import 'package:flutter/material.dart';

import 'package:rssreader/screens/catalog_screen.dart';
import 'package:rssreader/screens/settings_screen.dart';
import 'package:rssreader/screens/sources_screen.dart';

class ListDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Container(
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.only(bottom: 6.0),
              child: Text(
                'RSS Reader',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.0,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
              gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [
                  Colors.lightBlueAccent,
                  Colors.blueAccent,
                ],
              ),
            ),
          ),
          ListTile(
            title: Text('Catalog'),
            leading: Icon(Icons.grid_on),
            onTap: () {
              Navigator.popAndPushNamed(context, CatalogScreen.route);
            },
          ),
          ListTile(
            title: Text('Sources'),
            leading: Icon(Icons.library_add),
            onTap: () {
              Navigator.popAndPushNamed(context, SourcesScreen.route);
            },
          ),
          ListTile(
            title: Text('Settings'),
            leading: Icon(Icons.settings),
            onTap: () {
              Navigator.popAndPushNamed(context, SettingsScreen.route);
            },
          ),
          AboutListTile(
            icon: Icon(Icons.info_outline),
            child: Text("About"),
            applicationVersion: '1.0.0',
            applicationIcon: Icon(Icons.ac_unit),
            aboutBoxChildren: <Widget>[
              Text("A Simple RSS Reader."),
            ],
          )
        ],
      ),
    );
  }
}
