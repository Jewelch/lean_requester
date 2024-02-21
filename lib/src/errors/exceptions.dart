final class DecodingException implements Exception {
  final String message;

  const DecodingException(this.message);
}

final class ServerException implements Exception {}

final class CacheException implements Exception {}
