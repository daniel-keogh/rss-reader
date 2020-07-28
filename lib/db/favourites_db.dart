import 'package:sqflite/sqflite.dart';

import 'package:rssreader/db/db_manager.dart';
import 'package:rssreader/models/favourite.dart';

class FavouritesDb {
  final DbManager _db = DbManager.getInstance();

  static const String _TABLE_FAVOURITES = "favourites";

  static const String _COLUMN_ID = "id";
  static const String _COLUMN_TITLE = "title";
  static const String _COLUMN_IMAGE = "imageUrl";
  static const String _COLUMN_URL = "url";
  static const String _COLUMN_PUBLISHER = "publisher";
  static const String _COLUMN_DATE = "date";

  Future<Iterable<Favourite>> getAll() async {
    final Database db = await _db.database;

    final favs = await db.query(
      _TABLE_FAVOURITES,
      columns: [
        _COLUMN_ID,
        _COLUMN_TITLE,
        _COLUMN_IMAGE,
        _COLUMN_URL,
        _COLUMN_PUBLISHER,
        _COLUMN_DATE,
      ],
    );

    final favList = List<Favourite>();

    favs.forEach((element) {
      Favourite fav = Favourite.fromMap(element);
      favList.add(fav);
    });

    return favList;
  }

  Future<Favourite> getById(int id) async {
    final Database db = await _db.database;

    List<Map> maps = await db.query(
      _TABLE_FAVOURITES,
      columns: [
        _COLUMN_ID,
        _COLUMN_TITLE,
        _COLUMN_IMAGE,
        _COLUMN_URL,
        _COLUMN_PUBLISHER,
        _COLUMN_DATE,
      ],
      where: '$_COLUMN_ID = ?',
      whereArgs: [id],
    );

    if (maps.length > 0) {
      return Favourite.fromMap(maps.first);
    }

    return null;
  }

  Future<Favourite> insert(Favourite favourite) async {
    final Database db = await _db.database;

    favourite.id = await db.insert(
      _TABLE_FAVOURITES,
      favourite.toMap(),
    );

    return favourite;
  }

  Future<int> update(Favourite favourite) async {
    final Database db = await _db.database;

    return await db.update(
      _TABLE_FAVOURITES,
      favourite.toMap(),
      where: '$_COLUMN_ID = ?',
      whereArgs: [favourite.id],
    );
  }

  Future<int> deleteById(int id) async {
    final Database db = await _db.database;

    return await db.delete(
      _TABLE_FAVOURITES,
      where: '$_COLUMN_ID = ?',
      whereArgs: [id],
    );
  }
}
