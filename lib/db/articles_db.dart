import 'package:sqflite/sqflite.dart';

import 'package:rssreader/models/article.dart';
import 'package:rssreader/db/db_manager.dart';

class ArticlesDb {
  final _db = DbManager.getInstance();

  static const String _TABLE_ARTICLES = "articles";

  static const String _COLUMN_ID = "id";
  static const String _COLUMN_SUB_ID = "subscriptionId";
  static const String _COLUMN_TITLE = "title";
  static const String _COLUMN_URL = "url";
  static const String _COLUMN_IMAGE = "imageUrl";
  static const String _COLUMN_PUBLISHER = "publisher";
  static const String _COLUMN_CATEGORY = "category";
  static const String _COLUMN_DATE = "date";
  static const String _COLUMN_IS_READ = "isRead";

  Future<Iterable<Article>> getAll() async {
    final db = await _db.database;

    final articles = await db.query(
      _TABLE_ARTICLES,
      columns: [
        _COLUMN_ID,
        _COLUMN_SUB_ID,
        _COLUMN_TITLE,
        _COLUMN_URL,
        _COLUMN_IMAGE,
        _COLUMN_PUBLISHER,
        _COLUMN_CATEGORY,
        _COLUMN_DATE,
        _COLUMN_IS_READ,
      ],
    );

    return articles.map((e) => Article.fromMap(e));
  }

  Future<Iterable<Article>> insertAll(
    Iterable<Article> articles,
  ) async {
    final db = await _db.database;

    final batch = db.batch();

    final items = articles.toList();
    items.forEach((sub) {
      batch.insert(
        _TABLE_ARTICLES,
        sub.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });

    final ids = await batch.commit();

    // Set the id's of each article
    for (int i = 0; i < ids.length; i++) {
      items[i].id = i;
    }

    return items;
  }

  Future<void> updateReadStatus(Article article) async {
    final Database db = await _db.database;

    await db.update(
      _TABLE_ARTICLES,
      {
        "isRead": article.isRead ? 1 : 0,
      },
      where: '$_COLUMN_ID = ?',
      whereArgs: [article.id],
    );
  }

  Future<void> updateAllReadStatus(bool status) async {
    final Database db = await _db.database;

    await db.update(
      _TABLE_ARTICLES,
      {
        "isRead": status ? 1 : 0,
      },
    );
  }
}
