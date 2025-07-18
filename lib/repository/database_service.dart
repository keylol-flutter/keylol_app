import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const String historyDdl = '''
CREATE TABLE history (
  tid TEXT PRIMARY KEY, 
  fid TEXT, 
  author_id TEXT, 
  author TEXT, 
  subject TEXT, 
  dateline TEXT, 
  date TEXT
);
''';

const String favoriteDdl = '''
CREATE TABLE favorite (
  fav_id TEXT PRIMARY KEY, 
  uid TEXT, 
  id TEXT, 
  id_type TEXT, 
  space_uid TEXT, 
  title TEXT, 
  description TEXT, 
  dateline TEXT, 
  icon TEXT, 
  url TEXT, 
  author TEXT
);
''';

class DatabaseService {
  late final Database _db;

  Database get instance => _db;

  Future<void> init() async {
    _db = await openDatabase(
      join(await getDatabasesPath(), "keylol_flutter.db"),
      onCreate: (db, version) {
        db.execute(historyDdl);
        db.execute(favoriteDdl);
      },
      version: 1,
    );
  }
}
