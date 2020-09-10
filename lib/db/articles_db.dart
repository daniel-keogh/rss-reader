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
  static const String _COLUMN_DATE = "date";
  static const String _COLUMN_IS_READ = "isRead";

  Future<Iterable<Article>> getAll() async {
    final db = await _db.database;

    final articles = await db.rawQuery(
      """
      SELECT a.*, s.title AS "publisher", s.category
      FROM articles a JOIN subscriptions s
      ON a.subscriptionId = s.id
      """,
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

  Future<int> updateReadStatus(Article article) async {
    final db = await _db.database;

    return await db.update(
      _TABLE_ARTICLES,
      {
        _COLUMN_IS_READ: article.isRead ? 1 : 0,
      },
      where: '$_COLUMN_ID = ?',
      whereArgs: [article.id],
    );
  }

  Future<int> updateAllReadStatus(bool status) async {
    final db = await _db.database;

    return await db.update(
      _TABLE_ARTICLES,
      {
        _COLUMN_IS_READ: status ? 1 : 0,
      },
    );
  }

  Future<void> clear() async {
    final db = await _db.database;
    return await db.delete(_TABLE_ARTICLES);
  }
}
