part of "requester.dart";

mixin LeanRequesterMixin on LeanRequesterBase {
  Future<R> request<R, M extends DAO>({
    bool debugRequest = true,
    bool mockingEnabled = false,
    required M dao,
    bool asList = false,
    String? listKey,
    required String cachingKey,
    dynamic mockingData,
    required RestfullMethods method,
    required String path,
    String? baseUrl,
    dynamic body,
    ContentType? contentType,
    StringKeyedMap? extraHeaders,
    StringKeyedMap? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    int retryCount = 3,
    dynamic savePath,
    bool deleteOnError = true,
    String lengthHeader = Headers.contentLengthHeader,
  }) async {
    dio
      ..setupOptions(
        baseOptions,
        baseUrl,
        contentType,
        headers,
        extraHeaders,
      )
      ..setupInterceptors(
        queuedInterceptorsWrapper,
        debugRequest,
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
        mockingEnabled,
        mockingData,
        mockAwaitDurationMs,
      );

    final transformer = dio.transformer as _LeanTransformer<R, M>;

    if (!connectivityMonitor.isConnected) {
      return await transformer.transformCachedData(cachingKey);
    }

    if (mockingModeEnabled || mockingEnabled) {
      return await transformer.transformMockResponse();
    }

    for (int attempt = 0; attempt < retryCount; attempt++) {
      Debugger.red('Attempt $attempt for request to $path');

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
        if (attempt == retryCount - 1)
          throw ServerException(
            'Request to $path failed after $retryCount retries',
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
    throw ServerException('Unexpected error occurred while processing the request to $path.');
  }
}
