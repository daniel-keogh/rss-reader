import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:rssreader/components/confirm_dialog.dart';

import 'package:rssreader/models/favourite.dart';
import 'package:rssreader/providers/favourites_provider.dart';
import 'package:rssreader/components/article_bottom_sheet.dart';
import 'package:rssreader/screens/webview/webview_screen.dart';
import 'package:rssreader/utils/constants.dart';

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
                    bool confirmed = await showConfirmDialog(
                      context: context,
                      title: 'Delete',
                      message:
                          'Are you sure you want to delete all your favourites?',
                    );

                    if (confirmed) {
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
            shape: bottomSheetShape,
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
