import 'dart:math' show Random, min;

import 'package:cg_core_defs/helpers/debugging_printer.dart';
import 'package:lean_requester/lean_interceptor.dart';
import 'package:lean_requester/src/extensions/private_ext.dart';
import 'package:lean_requester/src/extensions/shared_ext.dart';

import './request_base.dart';

mixin LeanRequesterMixin on LeanRequesterBase {
  Future<R> request<R, M extends DAO>({
    required M dao,
    required String path,
    required RestfulMethods method,
    required String cachingKey,
    bool asList = false,
    String? listKey,
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
        cacheManager,
        cachingKey,
        dao,
        asList,
        listKey,
        mockIt,
        mockingData,
        mockAwaitDurationMs,
      );

    final transformer = dio.transformer as LeanTransformer<R, M>;

    if (!connectivityMonitor.isConnected) {
      return await transformer.transformCachedData(cachingKey);
    }

    if (mockingModeEnabled || mockIt) {
      return await transformer.transformMockResponse();
    }

    return await _attemptRequest(
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

  Future<R> _attemptRequest<R>({
    required String path,
    dynamic body,
    StringKeyedMap? queryParameters,
    required RestfulMethods method,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    for (int attempt = 0; attempt < maxRetriesPerRequest; attempt++) {
      if (attempt > 0)
        Debugger.red('Attempt ${attempt + 1} for request to ${baseOptions.baseUrl + path}');

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
      } catch (e) {
        if (attempt == maxRetriesPerRequest - 1)
          throw ServerException(
            'Request to ${baseOptions.baseUrl + path} failed after $maxRetriesPerRequest retries',
          );

        await Future.delayed(
          Duration(
            milliseconds: min(
              (1 << attempt) * retryDelayMs + Random().nextInt(1000),
              maxRetryDelayMs,
            ),
          ),
        );
      }
    }
    throw ServerException(
      'Unexpected error occurred while processing the request to $path.\n'
      'Method: ${method.name}\n'
      'Query Parameters: ${queryParameters?.toString() ?? 'None'}\n'
      'Body: ${body?.toString() ?? 'None'}',
    );
  }
}
