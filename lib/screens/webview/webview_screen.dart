import 'package:flutter/material.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';

import 'package:rssreader/models/article.dart';

class WebViewScreen extends StatelessWidget {
  final Article article;

  WebViewScreen({
    Key key,
    @required this.article,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article.publisher),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            tooltip: 'Share',
            onPressed: () async {
              await Share.share(article.url);
            },
          ),
          IconButton(
            icon: Icon(Icons.open_in_new),
            tooltip: 'Open in browser',
            onPressed: () async {
              if (await canLaunch(article.url)) {
                await launch(article.url);
              }
            },
          ),
        ],
      ),
      body: WebView(
        initialUrl: article.url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
