import 'package:flutter/material.dart';

import 'package:rssreader/components/list_drawer.dart';
import 'package:rssreader/services/networking.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.done_all),
            tooltip: 'Mark all as read',
            onPressed: () async {
              var nh = NetworkHelper();
              await nh.load();
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            tooltip: 'Search',
            onPressed: () {
              
            },
          ),
        ],
      ),
      drawer: ListDrawer(),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return ListTile(
            title: Text("Number $index"),
          );
        },
        itemCount: 10,
      ),
    );
  }
}
