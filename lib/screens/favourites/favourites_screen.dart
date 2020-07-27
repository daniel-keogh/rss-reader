import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:rssreader/providers/favourites_provider.dart';

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

          return ListView.builder(
            itemBuilder: (context, index) => ListTile(
              title: Text(favs[index].article.title),
            ),
            itemCount: model.favourites.length,
          );
        },
      ),
    );
  }
}
