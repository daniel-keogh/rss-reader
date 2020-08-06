import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';

import 'package:rssreader/providers/favourites_provider.dart';
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
      backgroundColor: Colors.black,
      body: SafeArea(
        child: WebView(
          key: UniqueKey(),
          debuggingEnabled: false,
          initialUrl: article.url,
          javascriptMode: JavascriptMode.unrestricted,
          gestureRecognizers: {
            Factory(() => EagerGestureRecognizer()),
          },
        ),
      ),
      bottomNavigationBar: _BottomAppBar(article: article),
    );
  }
}

class _BottomAppBar extends StatelessWidget {
  final Article article;

  const _BottomAppBar({
    Key key,
    @required this.article,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_back),
            tooltip: 'Back',
            onPressed: () => Navigator.pop(context),
          ),
          const Spacer(),
          IconButton(
            icon: Icon(Icons.share),
            tooltip: 'Share',
            onPressed: () async {
              await Share.share(article.url);
            },
          ),
          Consumer<FavouritesProvider>(
            builder: (context, model, child) {
              if (!model.contains(article)) {
                return IconButton(
                  icon: Icon(Icons.favorite_border),
                  tooltip: 'Favourite',
                  onPressed: () => model.add(article),
                );
              } else {
                return IconButton(
                  icon: Icon(Icons.favorite),
                  tooltip: 'Unfavourite',
                  onPressed: () => model.delete(article),
                );
              }
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
    );
  }
}
