import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:rssreader/models/subscription.dart';

class SubscriptionsDb {
  static const String _TABLE_SUBSCRIPTIONS = "subscriptions";

  static const String _COLUMN_ID = "id";
  static const String _COLUMN_TITLE = "title";
  static const String _COLUMN_CATEGORY = "category";
  static const String _COLUMN_URL = "xmlUrl";

  static final SubscriptionsDb _instance = SubscriptionsDb._();

  Database _database;

  SubscriptionsDb._();

  static SubscriptionsDb getInstance() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await createDatabase();
    }

    return _database;
  }

  Future<Database> createDatabase() async {
    String dbPath = await getDatabasesPath();

    return await openDatabase(
      join(dbPath, 'rssreader.sqlite'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          """CREATE TABLE $_TABLE_SUBSCRIPTIONS (
          $_COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT,
          $_COLUMN_TITLE TEXT NOT NULL,
          $_COLUMN_CATEGORY TEXT NOT NULL,
          $_COLUMN_URL TEXT UNIQUE NOT NULL
          )
          """,
        );
      },
    );
  }

  Future<Iterable<Subscription>> getAll() async {
    final db = await database;

    var subs = await db.query(
      _TABLE_SUBSCRIPTIONS,
      columns: [
        _COLUMN_ID,
        _COLUMN_TITLE,
        _COLUMN_CATEGORY,
        _COLUMN_URL,
      ],
    );

    var subsList = List<Subscription>();

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
    final db = await database;

    List<Map> maps = await db.query(
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
    final db = await database;

    subscription.id = await db.insert(
      _TABLE_SUBSCRIPTIONS,
      subscription.toMap(),
    );

    return subscription;
  }

  Future<void> insertAll(Iterable<Subscription> subscriptions) async {
    final db = await database;

    final Batch batch = db.batch();

    subscriptions.forEach((sub) {
      batch.insert(
        _TABLE_SUBSCRIPTIONS,
        sub.toMap(),
      );
    });

    await batch.commit(noResult: true);
  }

  Future<int> update(Subscription subscription) async {
    final db = await database;

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

  Future<int> _delete(String column, dynamic arg) async {
    final db = await database;

    return await db.delete(
      _TABLE_SUBSCRIPTIONS,
      where: '$column = ?',
      whereArgs: [arg],
    );
  }

  Future close() async {
    final db = await database;
    return await db.close();
  }
}
