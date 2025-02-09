import 'package:cg_core_defs/cg_core_defs.dart';

import '../core/transformer/definitons/response_transformation_strategy.dart';

abstract class CommonException implements Exception {
  final String message;

  CommonException(this.message) {
    Debugger.red(message);
  }
}

class UnsupportedDataTypeException extends CommonException {
  UnsupportedDataTypeException() : super('Unsupported data type encountered during decoding.');
}

class ResponseBodyException extends CommonException {
  factory ResponseBodyException.isNull() => ResponseBodyException._('Invalid or null response body.');

  factory ResponseBodyException.invalidStatusCode(int statusCode) =>
      ResponseBodyException._('Invalid response status code encountered ($statusCode)');

  ResponseBodyException._(super.message);
}

class ServerException extends CommonException {
  ServerException([String? message]) : super(message ?? 'Server exception occurred.');

  factory ServerException.maxRetriesReached(
    String path, {
    required int maxRetriesPerRequest,
  }) =>
      ServerException('Request to $path failed after $maxRetriesPerRequest retries');

  factory ServerException.unexpected(
    String path, {
    required String methodName,
  }) =>
      ServerException(
        'Unexpected error occurred while processing the request to $path.\n'
        'Method: $methodName\n',
      );
}

final class NonExistingCacheDataException extends CommonException {
  NonExistingCacheDataException(String? cacheKey)
      : super("The specified Cache Key [$cacheKey] does not exist in the cache data.");
}

final class DataDecodingException<M> extends CommonException {
  factory DataDecodingException.basedOn(
    RTStrategies strategy,
    dynamic exception,
    StackTrace s,
  ) =>
      switch (strategy) {
        RTStrategies.cache => DataDecodingException<M>._('Cache: $exception', s),
        RTStrategies.mock => DataDecodingException<M>._('Mock: $exception', s),
        RTStrategies.network => DataDecodingException<M>._('Network: $exception', s),
      };

  DataDecodingException._(
    dynamic exception,
    StackTrace stacktrace,
  ) : super("$M $exception\n$stacktrace");
}

final class ListKeyException extends CommonException {
  factory ListKeyException.notProvided() => ListKeyException._(
        "Received response is a Map, you have not provided a `listKey` though, you should be trying to anger me.",
      );

  factory ListKeyException.notExisting(String? listKey) => ListKeyException._(
        "The specified list key [$listKey] does not exist in the received response.",
      );

  factory ListKeyException.unexpected(String? listKey) => ListKeyException._(
        "You have specified [$listKey] as the List key, but received response is a list, you should be trying to fool me..",
      );

  ListKeyException._(super.message);
}
