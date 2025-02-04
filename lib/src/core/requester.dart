import 'dart:async';
import 'dart:math' show Random, min;

import 'package:awesome_dio_interceptor/awesome_dio_interceptor.dart';
import 'package:cg_core_defs/cache/cache_manager.dart';
import 'package:cg_core_defs/connectivity/connectivity_monitor.dart';
import 'package:lean_requester/models_exp.dart';

import '../definitions/restful_methods.dart';
import '../exports.dart';
import '../extensions/shared_ext.dart';

part '../extensions/private_ext.dart';
part '_transformer.dart';

abstract class LeanRequester extends _RequestPerformer with _PerformerMixin {
  static final Map<String, dynamic> headers = {};

  const LeanRequester(
    super.dio,
    super.cacheManager,
    super.connectivityMonitor,
  );
}

abstract interface class _RequestPerformer extends _BasePerformer implements _PerformerInterceptor {
  const _RequestPerformer(
    super.dio,
    super.cacheManager,
    super.connectivityMonitor,
  );
}

abstract interface class _BasePerformer {
  final Dio dio;
  final CacheManager cacheManager;
  final ConnectivityMonitor connectivityMonitor;

  const _BasePerformer(
    this.dio,
    this.cacheManager,
    this.connectivityMonitor,
  );
}

abstract interface class _PerformerInterceptor {
  //! Base Options
  BaseOptions baseOptions = BaseOptions(
    connectTimeout: const Duration(milliseconds: 20000),
    sendTimeout: const Duration(milliseconds: 20000),
    receiveTimeout: const Duration(milliseconds: 20000),
    contentType: ContentType.json.mimeType,
  );

  //? Interceptor
  QueuedInterceptorsWrapper? queuedInterceptorsWrapper;

  //& Mocking Mode Preference
  bool mockingModeEnabled = false;
  int mockAwaitDuraitonInMilliseconds = 600;
  int retryDelayInMilliseconds = 1000;
  int maxRetryDelayInMilliseconds = 10000;

  //$ Awesome Dio Interceptor Setup
  bool debuggingEnabled = false;
  bool logRequestHeaders = false;
  bool logResponseHeaders = false;
  bool logRequestTimeout = false;
}

mixin _PerformerMixin on _RequestPerformer {
  /// #### Throws one of following exceptions
  ///
  /// `MockingDataDecodingException`,`DataDecodingException`,`ServerException`
  Future<R> request<R, M extends DAO>({
    final bool debuggingRequest = true,
    final bool mockingEnabled = false,
    required M dao,
    final bool asList = false,
    String? listKey,
    required String cachingKey,
    final dynamic mockingData,
    required RestfullMethods method,
    required String path,
    String? baseUrl,
    final dynamic body,
    final ContentType? contentType,
    final StringKeyedMap? extraHeaders,
    final StringKeyedMap? queryParameters,
    final Options? options,
    final CancelToken? cancelToken,
    final ProgressCallback? onSendProgress,
    final ProgressCallback? onReceiveProgress,
    int retryCount = 3,

    //* ------------------  Download Request ------------------
    dynamic savePath,
    bool deleteOnError = true,
    String lengthHeader = Headers.contentLengthHeader,
    //* -------------------------------------------------------
  }) async {
    //* Options setup
    dio.options = _setupOptions(
      baseOptions,
      baseUrl,
      contentType,
      LeanRequester.headers..addIfAvailable(extraHeaders),
    );

    //@ Interceptors setup
    dio.interceptors
      ..clear()
      ..ifNotNullAdd(queuedInterceptorsWrapper)
      ..addBasedOnCondition(
          condition: debuggingRequest && debuggingEnabled,
          AwesomeDioInterceptor(
            logRequestHeaders: logRequestHeaders,
            logResponseHeaders: logResponseHeaders,
            logRequestTimeout: logRequestTimeout,
          ));

    //! Transofrmer setup
    dio.transformer =
        _setupTransformer<R, M>(cachingKey, dao, asList, listKey, mockingEnabled, mockingData);

    final dioTransformer = dio.transformer as _LeanTransformer<R, M>;

    //= No Connectivity
    if (!connectivityMonitor.isConnected) {
      return await dioTransformer.transformCachedData(cachingKey);
    }

    //$ Mocking Enabled
    if (mockingModeEnabled || mockingEnabled) {
      return await dioTransformer.transformMockResponse();
    }

    //* Real Calls handling

    for (int i = 0; i < retryCount; i++) {
      try {
        return (await dio.request(path,
                data: body,
                queryParameters: queryParameters,
                cancelToken: cancelToken,
                options: DioMixin.checkOptions(method.name, options),
                onSendProgress: onSendProgress,
                onReceiveProgress: onReceiveProgress))
            .data;
      } catch (_) {
        if (i == retryCount - 1)
          throw ServerException(
            'Request to $path failed after $retryCount retries with method $method and body $body',
          );

        /// Delays the execution for a duration calculated based on an exponential backoff strategy.
        ///
        /// The delay duration is calculated as follows:
        /// - The base duration is `(1 << i) * 1000` milliseconds, where `i` is an integer representing the current retry attempt.
        /// - A random value between 0 and 1000 milliseconds is added to the base duration to introduce jitter.
        /// - The total duration is capped at a maximum of 10 seconds.
        ///
        /// This approach helps to avoid overwhelming the server with repeated requests in case of failures.
        await Future.delayed(
          Duration(
              milliseconds: min((1 << i) * retryDelayInMilliseconds + Random().nextInt(1000),
                  maxRetryDelayInMilliseconds)),
        );
      }
    }
    throw ServerException('Unexpected error occurred while processing the request to $path.');
  }

  BaseOptions _setupOptions(
    BaseOptions? baseOptions,
    String? baseUrl,
    ContentType? contentType,
    StringKeyedMap? extraHeaders,
  ) {
    var options = baseOptions ?? BaseOptions();
    options
      ..baseUrl = baseUrl ?? options.baseUrl
      ..contentType = contentType?.mimeType ?? ContentType.json.mimeType
      ..headers.addExtraHeaders(extraHeaders);

    return options;
  }

  _LeanTransformer<R, M> _setupTransformer<R, M extends DAO>(
    String cachingKey,
    M dao,
    bool asList,
    String? listKey,
    bool mockingEnabled,
    dynamic mockingData,
  ) =>
      _LeanTransformer<R, M>(
        cacheManager,
        cachingKey,
        dao,
        asList,
        listKey,
        mockingData,
        mockingEnabled,
        mockAwaitDuraitonInMilliseconds,
      );
}
