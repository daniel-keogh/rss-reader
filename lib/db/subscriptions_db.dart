import 'package:sqflite/sqflite.dart';

import 'package:rssreader/db/db_manager.dart';
import 'package:rssreader/models/subscription.dart';

class SubscriptionsDb {
  final DbManager _db = DbManager.getInstance();

  static const String _TABLE_SUBSCRIPTIONS = "subscriptions";

  static const String _COLUMN_ID = "id";
  static const String _COLUMN_TITLE = "title";
  static const String _COLUMN_CATEGORY = "category";
  static const String _COLUMN_URL = "xmlUrl";

  Future<Iterable<Subscription>> getAll() async {
    final Database db = await _db.database;

    final subs = await db.query(
      _TABLE_SUBSCRIPTIONS,
      columns: [
        _COLUMN_ID,
        _COLUMN_TITLE,
        _COLUMN_CATEGORY,
        _COLUMN_URL,
      ],
    );

    final subsList = List<Subscription>();

    subs.forEach((element) {
      Subscription sub = Subscription.fromMap(element);
      subsList.add(sub);
    });

    return subsList;
  }

  Future<Subscription> getById(int id) async {
    return await _get(_COLUMN_ID, id);
  }

  Future<Subscription> getByXmlUrl(String xmlUrl) async {
    return await _get(_COLUMN_URL, xmlUrl);
  }

  Future<Subscription> _get(String column, dynamic arg) async {
    final Database db = await _db.database;

    final List<Map> maps = await db.query(
      _TABLE_SUBSCRIPTIONS,
      columns: [
        _COLUMN_ID,
        _COLUMN_TITLE,
        _COLUMN_CATEGORY,
        _COLUMN_URL,
      ],
      where: '$column = ?',
      whereArgs: [arg],
    );

    if (maps.length > 0) {
      return Subscription.fromMap(maps.first);
    }

    return null;
  }

  Future<Subscription> insert(Subscription subscription) async {
    final Database db = await _db.database;

    subscription.id = await db.insert(
      _TABLE_SUBSCRIPTIONS,
      subscription.toMap(),
    );

    return subscription;
  }

  Future<Iterable<Subscription>> insertAll(
    Iterable<Subscription> subscriptions,
  ) async {
    final Database db = await _db.database;

    final Batch batch = db.batch();

    final subs = subscriptions.toList();
    subs.forEach((sub) {
      batch.insert(
        _TABLE_SUBSCRIPTIONS,
        sub.toMap(),
      );
    });

    final ids = await batch.commit();

    // Set the id's of each subscription
    for (int i = 0; i < ids.length; i++) {
      subs[i].id = i;
    }

    return subs;
  }

  Future<int> update(Subscription subscription) async {
    final Database db = await _db.database;

    return await db.update(
      _TABLE_SUBSCRIPTIONS,
      subscription.toMap(),
      where: '$_COLUMN_ID = ?',
      whereArgs: [subscription.id],
    );
  }

  Future<int> deleteById(int id) async {
    return await _delete(_COLUMN_ID, id);
  }

  Future<int> deleteByXmlUrl(String xmlUrl) async {
    return await _delete(_COLUMN_URL, xmlUrl);
  }

  Future<int> deleteByCategory(String category) async {
    return await _delete(_COLUMN_CATEGORY, category);
  }

  Future<int> _delete(String column, dynamic arg) async {
    final Database db = await _db.database;

    return await db.delete(
      _TABLE_SUBSCRIPTIONS,
      where: '$column = ?',
      whereArgs: [arg],
    );
  }
}
