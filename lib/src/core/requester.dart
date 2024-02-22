import 'dart:async';

import 'package:awesome_dio_interceptor/awesome_dio_interceptor.dart';

import '../definitions/restful_methods.dart';
import '../exports.dart';
import '../extensions/shared_ext.dart';
import '../models/no_data_model.dart';

part '../extensions/private_ext.dart';
part '_transformer.dart';

abstract class LeanRequester extends _RequestPerformer with _PerformerMixin {
  const LeanRequester(super.dio);
}

abstract class _RequestPerformer extends _BasePerformer implements _PerformerInterceptor {
  const _RequestPerformer(super.dio);
}

interface class _BasePerformer {
  final Dio dio;
  const _BasePerformer(this.dio);
}

abstract interface class _PerformerInterceptor {
  //? Interceptor
  QueuedInterceptorsWrapper? queuedInterceptorsWrapper;

  //! Base Options
  BaseOptions baseOptions = BaseOptions(
    connectTimeout: const Duration(milliseconds: 20000),
    sendTimeout: const Duration(milliseconds: 20000),
    receiveTimeout: const Duration(milliseconds: 20000),
    contentType: ContentType.json.mimeType,
  );

  //& Mocking Mode Preference
  bool mockingModeEnabled = false;
  int mockAwaitDuraitonInMilliseconds = 600;

  //$ Awesome Dio Interceptor Setup
  bool logRequestHeaders = false;
  bool logResponseHeaders = false;
  bool logRequestTimeout = false;
}

mixin _PerformerMixin on _RequestPerformer {
  Future<M> performDecodingRequest<M extends DAO>({
    required M dao,
    final bool debugIt = true,
    final bool mockIt = false,
    final dynamic mockingData,
    final BaseOptions? baseOptions,
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
    dio.options = baseOptions ?? this.baseOptions;
    dio.options.baseUrl = baseUrl ?? dio.options.baseUrl;
    dio.options.contentType = contentType?.mimeType ?? ContentType.json.mimeType;
    dio.options.headers.addExtraHeaders(extraHeaders);

    //! Interceptors setup
    dio.interceptors
      ..clear()
      ..ifNotNullAdd(queuedInterceptorsWrapper)
      ..addBasedOnCondition(
          condition: debugIt,
          AwesomeDioInterceptor(
            logRequestHeaders: logRequestHeaders,
            logResponseHeaders: logResponseHeaders,
            logRequestTimeout: logRequestTimeout,
          ));

    //! Transofrmer setup
    dio.transformer = LeanTransformer(dao: dao, mockingData: mockingData, mocking: mockIt);

    if (mockingModeEnabled || mockIt) return (dio.transformer as LeanTransformer<M>).decodeMockingData();

    return switch (method) {
      RestfullMethods.get => Future<M>.value((await dio.get(
          path,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress,
        ))
            .data),
      RestfullMethods.post => Future<M>.value((await dio.post(
          path,
          data: body,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress,
        ))
            .data),
      RestfullMethods.put => Future<M>.value((await dio.put(
          path,
          data: body,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress,
        ))
            .data),
      RestfullMethods.patch => Future<M>.value((await dio.patch(
          path,
          data: body,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress,
        ))
            .data),
      RestfullMethods.delete => Future<M>.value((await dio.delete(
          path,
          data: body,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
        ))
            .data),
      RestfullMethods.download => Future<M>.value((await dio.download(
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
}
