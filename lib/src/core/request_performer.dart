import 'package:awesome_dio_interceptor/awesome_dio_interceptor.dart';

import '../definitions/restful_methods.dart';
import '../exports.dart';
import '../ext/shared_ext.dart';
import '../models/no_data_model.dart';

part '../ext/private_ext.dart';
part '_decoder.dart';

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
  /// The default [Transformer] for [Dio].
  ///
  /// [BackgroundTransformer] will do the deserialization of JSON in
  /// a background isolate if possible.
  static final _backgroundTransformer = BackgroundTransformer();

  Future<R?> performDecodingRequest<R, M extends DAO>({
    required M decodableModel,
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
    if (mockingModeEnabled || mockIt) return _decode(decodableModel, mockingData: mockingData, mocking: true) as R;

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
    dio.transformer = _backgroundTransformer;

    return switch (method) {
      RestfullMethods.get => dio
          .get(
            path,
            queryParameters: queryParameters,
            options: options,
            cancelToken: cancelToken,
            onReceiveProgress: onReceiveProgress,
          )
          .then((response) => _decode(decodableModel, response: response)),
      RestfullMethods.post => dio
          .post(
            path,
            data: body,
            queryParameters: queryParameters,
            options: options,
            cancelToken: cancelToken,
            onSendProgress: onSendProgress,
            onReceiveProgress: onReceiveProgress,
          )
          .then((response) => _decode(decodableModel, response: response)),
      RestfullMethods.put => dio
          .put(path,
              data: body,
              queryParameters: queryParameters,
              options: options,
              cancelToken: cancelToken,
              onSendProgress: onSendProgress,
              onReceiveProgress: onReceiveProgress)
          .then((response) => _decode(decodableModel, response: response)),
      RestfullMethods.patch => dio
          .patch(path,
              data: body,
              queryParameters: queryParameters,
              options: options,
              cancelToken: cancelToken,
              onSendProgress: onSendProgress,
              onReceiveProgress: onReceiveProgress)
          .then((response) => _decode(decodableModel, response: response)),
      RestfullMethods.delete => dio
          .delete(
            path,
            data: body,
            queryParameters: queryParameters,
            options: options,
            cancelToken: cancelToken,
          )
          .then((response) => _decode(decodableModel, response: response)),
      RestfullMethods.download => dio
          .download(
            path,
            savePath,
            onReceiveProgress: onReceiveProgress,
            data: body,
            queryParameters: queryParameters,
            deleteOnError: deleteOnError,
            lengthHeader: lengthHeader,
            options: options,
            cancelToken: cancelToken,
          )
          .then((response) => _decode(decodableModel, response: response)),
    };
  }
}
