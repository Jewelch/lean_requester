part of '../core/requester.dart';

extension _ListSecuredAdderExt<E> on List<E> {
  void ifNotNullAdd(E? element) {
    if (element == null) return;
    add(element);
  }

  void addBasedOnCondition(E element, {required bool condition}) {
    if (condition) add(element);
  }
}

extension DioComponentsExt on Dio {
  void setupOptions(
    BaseOptions baseOptions,
    String? baseUrl,
    ContentType? contentType,
    StringKeyedMap defaultHeaders,
    StringKeyedMap? extraHeaders,
  ) =>
      options = baseOptions
        ..baseUrl = baseUrl ?? baseOptions.baseUrl
        ..contentType = contentType?.mimeType ?? ContentType.json.mimeType
        ..headers.addExtraHeaders(extraHeaders)
        ..headers.addAll(defaultHeaders);

  void setupInterceptors(
    QueuedInterceptorsWrapper? queuedInterceptorsWrapper,
    bool debugRequest,
    bool debuggingEnabled,
    bool logRequestHeaders,
    bool logResponseHeaders,
    bool logRequestTimeout,
  ) =>
      interceptors
        ..clear()
        ..ifNotNullAdd(queuedInterceptorsWrapper)
        ..addBasedOnCondition(
          condition: debugRequest && debuggingEnabled,
          AwesomeDioInterceptor(
            logRequestHeaders: logRequestHeaders,
            logResponseHeaders: logResponseHeaders,
            logRequestTimeout: logRequestTimeout,
          ),
        );

  void setupTransformer<R, M extends DAO>(
    CacheManager cacheManager,
    String cachingKey,
    M dao,
    bool asList,
    String? listKey,
    bool mockingEnabled,
    dynamic mockingData,
    int mockAwaitDurationMs,
  ) =>
      transformer = _LeanTransformer<R, M>(
        cacheManager,
        cachingKey,
        dao,
        asList,
        listKey,
        mockingData,
        mockingEnabled,
        mockAwaitDurationMs,
      );
}
