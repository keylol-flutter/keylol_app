import 'package:keylol_api/keylol_api.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const String ddl =
    "CREATE TABLE history (tid TEXT PRIMARY KEY, fid TEXT, author_id TEXT, author TEXT, subject TEXT, dateline TEXT, date TEXT)";

class HistoryRepository {
  late final Future<Database> _database;

  Future<void> initial() async {
    _database = openDatabase(
      join(await getDatabasesPath(), 'keylol.db'),
      onCreate: (db, version) => db.execute(ddl),
      version: 1,
    );
  }

  Future<void> insertHistory(Thread thread) async {
    final db = await _database;

    await db.insert(
      'history',
      {
        'tid': thread.tid,
        'fid': thread.fid,
        'author_id': thread.authorId,
        'author': thread.author,
        'subject': thread.subject,
        'dateline': thread.dateline,
        'date': DateTime.now().toString()
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> count({String? text}) async {
    final db = await _database;

    if (text == null) {
      final result = await db.rawQuery('SELECT COUNT(0) FROM history');
      return Sqflite.firstIntValue(result) ?? 0;
    } else {
      final result = await db
          .rawQuery('SELECT COUNT(0) FROM history WHERE subject LIKE %$text%');
      return Sqflite.firstIntValue(result) ?? 0;
    }
  }

  Future<List<Map<String, dynamic>>> histories({
    String? text,
    int? page,
    int limit = 100,
  }) async {
    final db = await _database;

    int? offset = page == null ? null : (page - 1) * limit;
    final list = await db.query(
      'history',
      where: text != null ? 'subject LIKE ?' : null,
      whereArgs: text != null ? ['%$text%'] : null,
      orderBy: 'rowId DESC',
      offset: offset,
      limit: limit,
    );

    return list;
    // return List.generate(
    //   list.length,
    //   (index) => Thread.fromJson({
    //     'tid': list[index]['tid'],
    //     'fid': list[index]['fid'],
    //     'authorid': list[index]['author_id'],
    //     'author': list[index]['author'],
    //     'subject': list[index]['subject'],
    //     'dateline': list[index]['dateline']
    //   }),
    // );
  }
}
