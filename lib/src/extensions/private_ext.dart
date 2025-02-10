import 'package:awesome_dio_interceptor/awesome_dio_interceptor.dart';
import 'package:cg_core_defs/cache/cache_manager.dart';

import '../../lean_interceptor.dart';
import '../core/transformer/definitons/response_transformation_strategy.dart';
import 'shared_ext.dart';

extension ListSecuredAdderExt<E> on List<E> {
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
    bool debugIt,
    bool debuggingEnabled,
    bool logRequestHeaders,
    bool logResponseHeaders,
    bool logRequestTimeout,
  ) =>
      interceptors
        ..clear()
        ..ifNotNullAdd(queuedInterceptorsWrapper)
        ..addBasedOnCondition(
          condition: debugIt && debuggingEnabled,
          AwesomeDioInterceptor(
            logRequestHeaders: logRequestHeaders,
            logResponseHeaders: logResponseHeaders,
            logRequestTimeout: logRequestTimeout,
          ),
        );

  void setupTransformer<R, M extends DAO>(
    TransformerRequirements<M> requirements,
    CacheManager cacheManager,
    String cachingKey,
    dynamic mockingData,
    int mockAwaitDurationMs,
  ) =>
      transformer = LeanTransformer<R, M>(
        requirements: requirements,
        cacheManager: cacheManager,
        cachingKey: cachingKey,
        mockingData: mockingData,
        mockAwaitTime: mockAwaitDurationMs,
      );
}
