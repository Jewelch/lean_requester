import 'dart:math' show Random, min;

import 'package:cg_core_defs/helpers/debugging_printer.dart';

import '../../../lean_interceptor.dart';
import '../../extensions/private_ext.dart';
import '../../extensions/shared_ext.dart';
import '../transformer/definitons/response_transformation_strategy.dart';
import 'requester_configuration.dart';

mixin RequesterMixin on RequesterConfiguration {
  Future<R> request<R, M extends DAO>({
    TransformerRequirements<M>? requirements,
    M? requirement,
    required String path,
    required RestfulMethods method,
    required String cachingKey,
    bool debugIt = true,
    bool mockIt = false,
    dynamic mockingData,
    String? baseUrl,
    dynamic body,
    ContentType? contentType,
    StringKeyedMap? extraHeaders,
    StringKeyedMap? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    assert(
      requirement != null || requirements != null,
      'Either requirement (DAO) or requirements (DAO, asList, listKey) must be provided',
    );

    dio
      ..setupOptions(baseOptions, baseUrl, contentType, headers, extraHeaders)
      ..setupInterceptors(
        queuedInterceptorsWrapper,
        debugIt,
        debuggingEnabled,
        logRequestHeaders,
        logResponseHeaders,
        logRequestTimeout,
      )
      ..setupTransformer<R, M>(
        requirements ?? (dao: requirement!, asList: false, listKey: null),
        cacheManager,
        cachingKey,
        mockingData,
        mockAwaitDurationMs,
      );

    final transformer = dio.transformer as LeanTransformer<R, M>;

    if (!connectivityMonitor.isConnected) {
      return await transformer.transformCachedResponse();
    }

    if (mockingModeEnabled || mockIt) {
      return await transformer.transformMockedResponse();
    }

    return await _attemptNetworkRequest(
      path: path,
      body: body,
      queryParameters: queryParameters,
      method: method,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<R> _attemptNetworkRequest<R>({
    required String path,
    dynamic body,
    StringKeyedMap? queryParameters,
    required RestfulMethods method,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    for (int attempt = 1; attempt <= maxRetriesPerRequest; attempt++) {
      if (attempt > 1) Debugger.orange('Attempt $attempt for request to ${baseOptions.baseUrl + path}');

      try {
        final response = await dio.request(
          path,
          data: body,
          queryParameters: queryParameters,
          options: DioMixin.checkOptions(method.name, options),
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress,
        );
        return response.data;
      } on DioException catch (e) {
        Debugger.red("|| DioException<${e.type}, ${(e.error as CommonException).runtimeType}>");
        await _handleExceptions(attempt, path);
      } catch (e) {
        Debugger.red('Unexpected error during network request\n $e');
        await _handleExceptions(attempt, path);
      }
    }
    throw ServerException.unexpected(baseOptions.baseUrl + path, methodName: method.name);
  }

  Future<void> _handleExceptions(int attempt, String path) async {
    if (attempt == maxRetriesPerRequest)
      throw ServerException.maxRetriesReached(
        baseOptions.baseUrl + path,
        maxRetriesPerRequest: maxRetriesPerRequest,
      );

    await Future.delayed(_calculateDelayFor(attempt));
  }

  Duration _calculateDelayFor(int attempt) => Duration(
        milliseconds: min((1 << (attempt - 1)) * retryDelayMs + Random().nextInt(1000), maxRetryDelayMs),
      );
}
