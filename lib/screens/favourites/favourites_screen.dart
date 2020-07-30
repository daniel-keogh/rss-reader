import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:rssreader/models/favourite.dart';
import 'package:rssreader/providers/favourites_provider.dart';
import 'package:rssreader/screens/home/article_bottom_sheet.dart';
import 'package:rssreader/screens/webview/webview_screen.dart';

class FavouritesScreen extends StatelessWidget {
  final GlobalKey<AnimatedListState> _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Consumer<FavouritesProvider>(
      builder: (context, model, child) {
        final favs = model.favourites;
        final bool hasItems = favs.length != null && favs.length > 0;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Favourites'),
            actions: <Widget>[
              if (hasItems)
                IconButton(
                  icon: Icon(Icons.clear_all),
                  tooltip: 'Clear all',
                  onPressed: () async {
                    if (await _showConfirmationDialog(context)) {
                      Provider.of<FavouritesProvider>(
                        context,
                        listen: false,
                      ).deleteAll();
                    }
                  },
                ),
            ],
          ),
          body: hasItems
              ? Scrollbar(
                  child: AnimatedList(
                    key: _globalKey,
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    initialItemCount: favs.length,
                    itemBuilder: (context, index, animation) => _ListItem(
                      favourite: favs[index],
                      index: index,
                      animation: animation,
                      onDelete: () => _deleteItem(index),
                    ),
                  ),
                )
              : Center(
                  child: Text("You don't have any favourites."),
                ),
        );
      },
    );
  }

  void _deleteItem(int index) {
    _globalKey.currentState.removeItem(
      index,
      (context, animation) => SizeTransition(
        sizeFactor: animation,
        child: const ListTile(),
      ),
    );
  }

  Future<bool> _showConfirmationDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text(
                  'Are you sure you want to delete all your favourites?',
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text('CANCEL'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            FlatButton(
              child: const Text('YES'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );
  }
}

class _ListItem extends StatelessWidget {
  final Favourite favourite;
  final int index;
  final Animation animation;
  final Function onDelete;

  _ListItem({
    Key key,
    @required this.favourite,
    @required this.index,
    @required this.animation,
    @required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: animation,
      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.only(bottom: 6.0),
          child: Text(
            favourite.article.title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        subtitle: Text(
          favourite.article.publisher,
          style: const TextStyle(fontSize: 12),
        ),
        leading: favourite.article.imageUrl != null
            ? Image.network(favourite.article.imageUrl)
            : null,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WebViewScreen(
                article: favourite.article,
              ),
            ),
          );
        },
        onLongPress: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: const BorderRadius.vertical(
                top: const Radius.circular(10.0),
              ),
            ),
            builder: (context) => ArticleBottomSheet(
              article: favourite.article,
              onUnfavourite: onDelete,
            ),
          );
        },
      ),
    );
  }
}
