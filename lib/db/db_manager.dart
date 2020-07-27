import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbManager {
  Database _database;

  static final DbManager _instance = DbManager._();

  DbManager._();

  static DbManager getInstance() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await _createDatabase();
    }
    return _database;
  }

  Future<Database> _createDatabase() async {
    final String dbPath = await getDatabasesPath();

    return await openDatabase(
      join(dbPath, 'rssreader.sqlite'),
      version: 1,
      onCreate: (db, version) async {
        final Batch batch = db.batch();

        batch.execute(
          """
          CREATE TABLE IF NOT EXISTS "subscriptions" (
            "id" INTEGER PRIMARY KEY AUTOINCREMENT,
            "title" TEXT NOT NULL,
            "category" TEXT NOT NULL,
            "xmlUrl" TEXT NOT NULL UNIQUE
          );
          """,
        );

        batch.execute(
          """
          CREATE TABLE IF NOT EXISTS "favourites" (
            "id" INTEGER PRIMARY KEY AUTOINCREMENT,
            "title" TEXT NOT NULL,
            "imageUrl" TEXT,
            "publisher" TEXT NOT NULL,
            "date" TEXT NOT NULL,
            "url" TEXT NOT NULL UNIQUE
          );
          """,
        );

        await batch.commit(
          noResult: true,
          continueOnError: false,
        );
      },
    );
  }

  Future<void> close() async {
    final Database db = await database;
    return await db.close();
  }
}
