import 'package:flutter/material.dart';

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
            title: Text('Settings'),
            leading: Icon(Icons.settings),
            onTap: () {
              Navigator.popAndPushNamed(context, '/settings');
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
