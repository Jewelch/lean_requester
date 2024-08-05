import 'dart:async';

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

  //$ Awesome Dio Interceptor Setup
  bool logRequestHeaders = false;
  bool logResponseHeaders = false;
  bool logRequestTimeout = false;
}

mixin _PerformerMixin on _RequestPerformer {
  /// #### Throws one of following exceptions
  ///
  /// `MockingDataDecodingException`,`DataDecodingException`,`DataDecodingException`,`ServerException`
  Future<R> performDecodingRequest<R, M extends DAO>({
    final bool deuggingEnabled = true,
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
    //* ------------------  Download Request ------------------
    dynamic savePath,
    bool deleteOnError = true,
    String lengthHeader = Headers.contentLengthHeader,
    //* -------------------------------------------------------
  }) async {
    //= No Connectivity handling
    if (!connectivityMonitor.isConnected) return _restoreCachedData(cachingKey, dao, asList);

    //@ Interceptors setup
    dio.interceptors
      ..clear()
      ..ifNotNullAdd(queuedInterceptorsWrapper)
      ..addBasedOnCondition(
          condition: deuggingEnabled,
          AwesomeDioInterceptor(
            logRequestHeaders: logRequestHeaders,
            logResponseHeaders: logResponseHeaders,
            logRequestTimeout: logRequestTimeout,
          ));

    dio
      //* Options setup
      ..options = setupOptions(
        baseOptions,
        baseUrl,
        contentType,
        LeanRequester.headers..addIfAvailable(extraHeaders),
      )
      //! Transofrmer setup
      ..transformer = _setupTransformer<R, M>(cachingKey, dao, asList, listKey, mockingEnabled, mockingData);

    //$ Mocking Enabled handling
    if (mockingModeEnabled || mockingEnabled) return (dio.transformer as _LeanTransformer<R, M>).decodeMockingData();

    //* Real Calls handling
    return switch (method) {
      RestfullMethods.get => Future<R>.value((await dio.get(
          path,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress,
        ))
            .data),
      RestfullMethods.post => Future<R>.value((await dio.post(
          path,
          data: body,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress,
        ))
            .data),
      RestfullMethods.put => Future<R>.value((await dio.put(
          path,
          data: body,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress,
        ))
            .data),
      RestfullMethods.patch => Future<R>.value((await dio.patch(
          path,
          data: body,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress,
        ))
            .data),
      RestfullMethods.delete => Future<R>.value((await dio.delete(
          path,
          data: body,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
        ))
            .data),
      RestfullMethods.download => Future<R>.value((await dio.download(
          path,
          savePath,
          onReceiveProgress: onReceiveProgress,
          data: body,
          queryParameters: queryParameters,
          deleteOnError: deleteOnError,
          lengthHeader: lengthHeader,
          options: options,
          cancelToken: cancelToken,
        ))
            .data),
    };
  }

  R _restoreCachedData<R, M extends DAO>(
    String cachingKey,
    M dao,
    bool asList,
  ) {
    final cachedDataSting = cacheManager.getString(cachingKey);

    if (cachedDataSting != null) {
      return (asList ? DaoList(item: dao, key: cachingKey) : dao).fromJson(jsonDecode(cachedDataSting));
    } else {
      throw CacheException();
    }
  }

  BaseOptions setupOptions(
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
          cacheManager, cachingKey, dao, asList, listKey, mockingData, mockingEnabled, mockAwaitDuraitonInMilliseconds);
}
