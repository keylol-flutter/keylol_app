import 'package:keylol_api/keylol_api.dart';
import 'package:keylol_flutter/config/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class FavoriteRepository {
  final SharedPreferences _prefs;
  final Keylol _client;
  late final Database _db;

  FavoriteRepository(this._prefs, this._db, this._client);

  Future<void> autoReload() async {
    final lastUpdateTimeInt = _prefs.getInt('favorite.lastUpdateTime');
    bool isReload = false;
    if (lastUpdateTimeInt == null) {
      isReload = true;
    } else {
      final lastUpdateTime =
          DateTime.fromMicrosecondsSinceEpoch(lastUpdateTimeInt);
      isReload = DateTime.now()
          .subtract(const Duration(hours: 1))
          .isAfter(lastUpdateTime);
    }

    if (!isReload) {
      return;
    }

    await reload();
  }

  Future<void> reload() async {
    List<FavThread> favThreads = [];

    var page = 1;
    while (true) {
      final myFavThreadResp = await _client.myFavThread(page++);
      final myFavThread = myFavThreadResp.variables;
      if (myFavThread.list.isEmpty) {
        break;
      }
      favThreads.addAll(myFavThread.list);
    }

    if (favThreads.isEmpty) {
      return;
    }

    await _db.delete('favorite');

    final batch = _db.batch();
    for (final favThread in favThreads) {
      batch.insert(
        'favorite',
        {
          'fav_id': favThread.favId,
          'uid': favThread.uid,
          'id': favThread.id,
          'id_type': favThread.idType,
          'space_uid': favThread.spaceUid,
          'title': favThread.title,
          'description': favThread.description,
          'dateline': favThread.dateline,
          'icon': favThread.icon,
          'url': favThread.url,
          'author': favThread.author,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit();

    await _prefs.setInt(
      'favorite.lastUpdateTime',
      DateTime.now().microsecondsSinceEpoch,
    );
  }

  Future<ApiResponse<DefaultVariables>> add(
      String tid, String description, String formHash) async {
    final resp = await _client.favThread(tid, description, formHash);

    await reload();

    return resp;
  }

  Future<void> remove(String tid, String formHash) async {
    final results =
        await _db.query('favorite', where: 'id = ?', whereArgs: [tid]);
    if (results.isEmpty) {
      return;
    }

    final favId = results[0]['fav_id'] as String;
    final resp = await _client.deleteFavThread(favId, formHash);
    if (resp.message != null) {
      talker.error('取消收藏帖子失败 message: ${resp.message}');
    }

    await _db.delete('favorite', where: 'fav_id = ?', whereArgs: [favId]);
  }

  Future<bool> favored(String tid) async {
    await autoReload();

    final results =
        await _db.query('favorite', where: 'id = ?', whereArgs: [tid]);
    return results.isNotEmpty;
  }
}
