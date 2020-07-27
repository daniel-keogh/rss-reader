import 'dart:collection';

import 'package:flutter/foundation.dart';

import 'package:rssreader/db/favourites_db.dart';
import 'package:rssreader/models/article.dart';
import 'package:rssreader/models/favourite.dart';

class FavouritesProvider extends ChangeNotifier {
  Set<Favourite> _favourites = HashSet();

  final _db = FavouritesDb();

  FavouritesProvider() {
    _init();
  }

  Future<void> _init() async {
    _favourites = (await _db.getAll()).toSet();

    notifyListeners();
  }

  UnmodifiableListView<Favourite> get favourites {
    return UnmodifiableListView(_favourites);
  }

  void add(Article article) {
    final fav = Favourite(article: article);

    _favourites.add(fav);

    try {
      _db.insert(fav);
    } catch (e) {
      print(e);
    }

    notifyListeners();
  }

  bool contains(Article article) {
    return _favourites.where((e) => e.article == article).length > 0;
  }

  void delete(Article article) {
    final fav = _favourites.firstWhere((e) => e.article == article);

    _favourites.remove(fav);

    try {
      _db.deleteById(fav.id);
    } catch (e) {
      print(e);
    }

    notifyListeners();
  }
}
