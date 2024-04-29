import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

Future<CacheOptions> option() async {
  return CacheOptions(
    store: MemCacheStore(),
    keyBuilder: CacheOptions.defaultCacheKeyBuilder,
  );
}
