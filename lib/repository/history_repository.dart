import 'package:keylol_api/keylol_api.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const String ddl =
    'CREATE TABLE history (tid TEXT PRIMARY KEY, fid TEXT, author_id TEXT, author TEXT, subject TEXT, dateline TEXT, date TEXT)';

class HistoryRepository {
  final Database _db;

  HistoryRepository._(this._db);

  static HistoryRepository? _instance;

  static Future<HistoryRepository> getInstance() async {
    if (_instance != null) {
      return _instance!;
    }

    final db = await openDatabase(
      join(await getDatabasesPath(), 'history.db'),
      onCreate: (db, version) async {
        await db.execute(ddl);
      },
      version: 1,
    );
    _instance = HistoryRepository._(db);
    return _instance!;
  }

  Future<void> insertHistory(Thread thread) async {
    await _db.insert(
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
    if (text == null) {
      final result = await _db.rawQuery('SELECT COUNT(0) FROM history');
      return Sqflite.firstIntValue(result) ?? 0;
    } else {
      final result = await _db
          .rawQuery('SELECT COUNT(0) FROM history WHERE subject LIKE %$text%');
      return Sqflite.firstIntValue(result) ?? 0;
    }
  }

  Future<List<Map<String, dynamic>>> histories({
    String? text,
    int? page,
    int limit = 100,
  }) async {
    int? offset = page == null ? null : (page - 1) * limit;
    final list = await _db.query(
      'history',
      where: text != null ? 'subject LIKE ?' : null,
      whereArgs: text != null ? ['%$text%'] : null,
      orderBy: 'rowId DESC',
      offset: offset,
      limit: limit,
    );

    return list;
  }
}
