import 'package:flutter/material.dart';

import 'package:rssreader/screens/home_screen.dart';

void main() => runApp(RssReader());

class RssReader extends StatelessWidget {
  static const String _title = 'RSS Reader';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      theme: ThemeData(),
      home: HomeScreen(),
    );
  }
}
