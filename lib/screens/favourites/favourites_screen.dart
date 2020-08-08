import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:rssreader/components/article_bottom_sheet.dart';
import 'package:rssreader/components/confirm_dialog.dart';
import 'package:rssreader/models/favourite.dart';
import 'package:rssreader/providers/favourites_provider.dart';
import 'package:rssreader/providers/settings_provider.dart';
import 'package:rssreader/screens/home/article_item.dart';
import 'package:rssreader/utils/constants.dart';

class FavouritesScreen extends StatelessWidget {
  final GlobalKey<AnimatedListState> _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Consumer<FavouritesProvider>(
      builder: (context, model, child) {
        final favs = model.favourites;
        final hasItems = favs != null && favs.isNotEmpty;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Favourites'),
            actions: <Widget>[
              if (hasItems)
                IconButton(
                  icon: const Icon(Icons.clear_all),
                  tooltip: 'Clear all',
                  onPressed: () async {
                    final confirmed = await showConfirmDialog(
                      context: context,
                      title: 'Clear',
                      message:
                          'Are you sure you want to clear all your favourites?',
                    );

                    if (confirmed) {
                      model.deleteAll();
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
                      animation: animation,
                      onDelete: () => _deleteItem(index),
                    ),
                  ),
                )
              : const Center(
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
        child: Container(
          color: Colors.grey.withOpacity(0.1),
          child: const ListTile(),
        ),
      ),
    );
  }
}

class _ListItem extends StatelessWidget {
  final Favourite favourite;
  final Animation animation;
  final Function onDelete;

  _ListItem({
    Key key,
    @required this.favourite,
    @required this.animation,
    @required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: animation,
      child: Selector<SettingsProvider, OpenIn>(
        selector: (context, settings) => settings.openIn,
        builder: (context, openIn, child) => ArticleItem(
          openIn: openIn,
          article: favourite.article,
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
      ),
    );
  }
}
