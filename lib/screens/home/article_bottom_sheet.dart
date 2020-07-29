import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:rssreader/models/article.dart';
import 'package:rssreader/providers/favourites_provider.dart';
import 'package:rssreader/screens/webview/webview_screen.dart';

class ArticleBottomSheet extends StatelessWidget {
  final Article article;

  const ArticleBottomSheet({
    Key key,
    @required this.article,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<FavouritesProvider>(context, listen: false);

    return Wrap(
      children: <Widget>[
        ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          physics: const NeverScrollableScrollPhysics(),
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.open_in_browser),
              title: const Text("Open"),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WebViewScreen(
                      article: article,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.open_in_new),
              title: const Text("Open Externally"),
              onTap: () async {
                Navigator.pop(context);

                if (await canLaunch(article.url)) {
                  await launch(article.url);
                }
              },
            ),
            if (!model.contains(article))
              ListTile(
                leading: const Icon(Icons.favorite_border),
                title: const Text("Favourite"),
                onTap: () {
                  Navigator.pop(context);
                  model.add(article);
                },
              )
            else
              ListTile(
                leading: const Icon(Icons.favorite),
                title: const Text("Unfavourite"),
                onTap: () {
                  Navigator.pop(context);
                  model.delete(article);
                },
              ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text("Share"),
              onTap: () async {
                Navigator.pop(context);

                await Share.share(article.url);
              },
            ),
          ],
        ),
      ],
    );
  }
}
