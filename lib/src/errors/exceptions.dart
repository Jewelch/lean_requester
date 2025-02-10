import 'package:cg_core_defs/cg_core_defs.dart';

import '../core/transformer/definitons/response_transformation_strategy.dart';

abstract class CommonException implements Exception {
  final String message;

  CommonException(this.message) {
    Debugger.red('$runtimeType: $message');
  }
}

class UnsupportedDataTypeException extends CommonException {
  UnsupportedDataTypeException(Type runtimeType)
      : super('Unsupported data type encountered during decoding: $runtimeType');
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
  NonExistingCacheDataException(String? cacheKey) : super("Cache key [$cacheKey] not found in cache.");
}

final class DataDecodingException<M> extends CommonException {
  factory DataDecodingException.basedOn(
    TransformerStrategies strategy,
    dynamic exception,
    StackTrace s,
  ) =>
      switch (strategy) {
        TransformerStrategies.cache => DataDecodingException<M>._('Cache: $exception', s),
        TransformerStrategies.mock => DataDecodingException<M>._('Mock: $exception', s),
        TransformerStrategies.network => DataDecodingException<M>._('Network: $exception', s),
      };

  DataDecodingException._(
    dynamic exception,
    StackTrace stacktrace,
  ) : super("$M $exception\n$stacktrace");
}

final class ListKeyException extends CommonException {
  factory ListKeyException.notProvided() => ListKeyException._(
        "Response is a Map, but no `listKey` provided.",
      );

  factory ListKeyException.notExisting(String? listKey) => ListKeyException._(
        "List key '$listKey' not found in response.",
      );

  factory ListKeyException.unexpected(String? listKey) => ListKeyException._(
        "Expected a Map with key '$listKey', but received a List instead.",
      );

  ListKeyException._(super.message);
}
