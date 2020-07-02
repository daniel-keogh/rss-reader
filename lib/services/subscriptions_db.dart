import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:rssreader/models/subscription.dart';

class SubscriptionsDb {
  static const String TABLE_SUBSCRIPTIONS = "subscriptions";

  static const String COLUMN_ID = "id";
  static const String COLUMN_TITLE = "title";
  static const String COLUMN_CATEGORY = "category";
  static const String COLUMN_URL = "xmlUrl";

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
          """CREATE TABLE $TABLE_SUBSCRIPTIONS (
          $COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT,
          $COLUMN_TITLE TEXT NOT NULL,
          $COLUMN_CATEGORY TEXT NOT NULL,
          $COLUMN_URL TEXT NOT NULL
          )
          """,
        );
      },
    );
  }

  Future<List<Subscription>> getAll() async {
    final db = await database;

    var subs = await db.query(
      TABLE_SUBSCRIPTIONS,
      columns: [
        COLUMN_ID,
        COLUMN_TITLE,
        COLUMN_CATEGORY,
        COLUMN_URL,
      ],
    );

    var subsList = List<Subscription>();
    subs.forEach((element) {
      Subscription sub = Subscription.fromMap(element);
      subsList.add(sub);
    });

    return subsList;
  }

  Future<Subscription> get(int id) async {
    final db = await database;

    List<Map> maps = await db.query(
      TABLE_SUBSCRIPTIONS,
      columns: [
        COLUMN_ID,
        COLUMN_TITLE,
        COLUMN_CATEGORY,
        COLUMN_URL,
      ],
      where: '$COLUMN_ID = ?',
      whereArgs: [id],
    );

    if (maps.length > 0) {
      return Subscription.fromMap(maps.first);
    }

    return null;
  }

  Future<Subscription> insert(Subscription subscription) async {
    final db = await database;

    subscription.id = await db.insert(
      TABLE_SUBSCRIPTIONS,
      subscription.toMap(),
    );

    return subscription;
  }

  Future<int> update(Subscription subscription) async {
    final db = await database;

    return await db.update(
      TABLE_SUBSCRIPTIONS,
      subscription.toMap(),
      where: '$COLUMN_ID = ?',
      whereArgs: [subscription.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await database;

    return await db.delete(
      TABLE_SUBSCRIPTIONS,
      where: '$COLUMN_ID = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await database;
    return await db.close();
  }
}
