import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:rssreader/models/favourite.dart';
import 'package:rssreader/providers/favourites_provider.dart';
import 'package:rssreader/screens/home/article_bottom_sheet.dart';
import 'package:rssreader/screens/webview/webview_screen.dart';

class FavouritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favourites'),
      ),
      body: Consumer<FavouritesProvider>(
        builder: (context, model, child) {
          final favs = model.favourites;

          if (favs.length == 0) {
            return LinearProgressIndicator();
          }

          return Scrollbar(
            child: ListView.separated(
              itemBuilder: (context, index) {
                var item = favs[index];

                return _ListItem(
                  favourite: item,
                  handleTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WebViewScreen(
                          article: item.article,
                        ),
                      ),
                    );
                  },
                  handleLongPress: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: const BorderRadius.vertical(
                          top: const Radius.circular(10.0),
                        ),
                      ),
                      builder: (context) => ArticleBottomSheet(
                        article: item.article,
                      ),
                    );
                  },
                );
              },
              separatorBuilder: (context, index) {
                return const Divider(thickness: 0.5);
              },
              itemCount: favs.length,
              padding: const EdgeInsets.symmetric(vertical: 10.0),
            ),
          );
        },
      ),
    );
  }
}

class _ListItem extends StatelessWidget {
  final Favourite favourite;
  final Function handleTap;
  final Function handleLongPress;

  _ListItem({
    Key key,
    @required this.favourite,
    @required this.handleTap,
    @required this.handleLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Padding(
        padding: EdgeInsets.only(bottom: 6.0),
        child: Text(
          favourite.article.title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      subtitle: Text(
        favourite.article.publisher,
        style: TextStyle(fontSize: 12),
      ),
      leading: favourite.article.imageUrl != null
          ? Image.network(favourite.article.imageUrl)
          : null,
      onTap: handleTap,
      onLongPress: handleLongPress,
    );
  }
}
