import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_db_store/dio_cache_interceptor_db_store.dart';
import 'package:sqflite/sqflite.dart';

Future<CacheOptions> option() async {
  return CacheOptions(
      store: MemCacheStore(),
      // store: DbCacheStore(databasePath: await getDatabasesPath()),
      keyBuilder: CacheOptions.defaultCacheKeyBuilder);
}
