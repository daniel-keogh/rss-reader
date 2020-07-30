import 'dart:collection';

import 'package:flutter/foundation.dart';

import 'package:rssreader/db/favourites_db.dart';
import 'package:rssreader/models/article.dart';
import 'package:rssreader/models/favourite.dart';

class FavouritesProvider extends ChangeNotifier {
  Set<Favourite> _favourites = HashSet<Favourite>();

  final _db = FavouritesDb();

  FavouritesProvider() {
    _init();
  }

  Future<void> _init() async {
    _favourites.addAll(await _db.getAll());

    notifyListeners();
  }

  UnmodifiableListView<Favourite> get favourites {
    return UnmodifiableListView(_favourites);
  }

  void add(Article article) {
    final fav = Favourite.fromArticle(article);

    if (_favourites.add(fav)) {
      try {
        _db.insert(fav);
      } catch (e) {
        print(e);
      }

      notifyListeners();
    }
  }

  bool contains(Article article) {
    return _favourites.contains(
      Favourite.fromArticle(article),
    );
  }

  void delete(Article article) {
    final fav = _favourites.lookup(
      Favourite.fromArticle(article),
    );

    if (_favourites.remove(fav)) {
      try {
        _db.deleteById(fav.id);
      } catch (e) {
        print(e);
      }

      notifyListeners();
    }
  }

  void deleteAll() {
    _favourites.clear();

    try {
      _db.deleteAll();
    } catch (e) {
      print(e);
    }

    notifyListeners();
  }
}
