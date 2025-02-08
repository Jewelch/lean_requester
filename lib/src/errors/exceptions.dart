import 'package:cg_core_defs/cg_core_defs.dart';

abstract class CommonException implements Exception {
  final String message;

  CommonException(this.message) {
    Debugger.red(message);
  }
}

class UnsupportedDataTypeException extends CommonException {
  UnsupportedDataTypeException()
      : super('Unsupported data type encountered during decoding.');
}

class InvalidResponseStatusCode extends CommonException {
  InvalidResponseStatusCode(int statusCode)
      : super('Invalid response status code encountered ($statusCode)');
}

final class DataDecodingException<M> extends CommonException {
  factory DataDecodingException.cache(dynamic e, StackTrace s) =>
      DataDecodingException._('Cache: $e', s);

  factory DataDecodingException.mock(dynamic e, StackTrace s) =>
      DataDecodingException._('Mock: $e', s);

  factory DataDecodingException.network(dynamic e, StackTrace s) =>
      DataDecodingException._('Network: $e', s);

  DataDecodingException._(dynamic exception, StackTrace stacktrace)
      : super("$M $exception\n$stacktrace");
}

final class ListKeyException extends CommonException {
  factory ListKeyException.notProvided() => ListKeyException._(
      "Received response is a Map, you have not provided a `listKey` though, you should be trying to anger me.");

  factory ListKeyException.notExisting(String? listKey) => ListKeyException._(
      "The specified list key [$listKey] does not exist in the received response.");

  factory ListKeyException.unexpected(String? listKey) => ListKeyException._(
        "You have specified [$listKey] as the List key, but received response is a list, you should be trying to fool me..",
      );

  ListKeyException._(super.message);
}

class ServerException extends CommonException {
  ServerException([String? message])
      : super(message ?? 'Server exception occurred.');
}

final class NonExistingCacheDataException extends CommonException {
  NonExistingCacheDataException(String? cacheKey)
      : super(
            "The specified Cache Key [$cacheKey] does not exist in the cache data.");
}
