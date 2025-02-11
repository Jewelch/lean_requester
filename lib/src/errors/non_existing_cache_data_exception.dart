import 'common_exception.dart';

final class NonExistingCacheDataException extends CommonException {
  NonExistingCacheDataException(String? cacheKey) : super("Cache key [$cacheKey] not found in cache.");
}
