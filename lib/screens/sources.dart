import 'dart:io';

import 'package:flutter/material.dart';

import 'package:rssreader/services/subscriptions.dart';

class SourcesScreen extends StatelessWidget {
  final _subs = Subscriptions();

  SnackBar _getSnackBar(String text) {
    return SnackBar(
      content: Text(text),
      action: SnackBarAction(
        onPressed: () {},
        label: 'OK',
      ),
      duration: Duration(seconds: 5),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sources'),
        actions: <Widget>[
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.insert_drive_file),
              tooltip: 'Export',
              onPressed: () async {
                File file = await _subs.export();

                if (file != null) {
                  var msg = "File exported to: '${file.path}'";
                  Scaffold.of(context).showSnackBar(_getSnackBar(msg));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
