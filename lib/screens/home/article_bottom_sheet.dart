import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:rssreader/screens/webview/webview_screen.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:rssreader/models/article.dart';
import 'package:rssreader/providers/favourites_provider.dart';

class ArticleBottomSheet extends StatelessWidget {
  final Article article;

  const ArticleBottomSheet({
    Key key,
    @required this.article,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<FavouritesProvider>(context, listen: false);
    final bool isFav = model.contains(article);

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
            ListTile(
              leading: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
              ),
              title: Text(
                isFav ? "Unfavourite" : "Favourite",
              ),
              onTap: () {
                Navigator.pop(context);

                if (isFav) {
                  model.delete(article);
                } else {
                  model.add(article);
                }
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
